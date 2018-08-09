require "sinatra"
require "sinatra/reloader"
require_relative "models/konto_manager"
require_relative "models/konto"
require_relative "models/ueberweisung"

enable :sessions

# index------------------------------------------

get "/" do
  erb :index
end

# create_konto-----------------------------------

get "/create_konto" do
  erb :create_konto
end

post "/create" do
  if params["konto_nr"].size == 4
    if konto_manager.konten[params["konto_nr"].to_s].nil?
      if params["pin"].size == 3
        konto_manager.add_new_konto(params["konto_nr"], params["pin"], 0)
        konto_manager.store_to_file
        redirect "/"
      else
        @message = "Die Pin muss aus 3 Ziffern und/oder Buchstaben bestehen"
        erb :create_konto
      end
    else
      @message = "Die angegebene Kontonummer existiert bereits"
      erb :create_konto
    end
  else
    @message = "Die Kontonummer muss aus 4 Ziffern bestehen"
    erb :create_konto
  end
end

# delete_konto-----------------------------------

get "/delete_konto" do
  erb :delete_konto
end

post "/delete" do
  @lösche_konto = konto_manager.konten[params["lösche_konto_nr"].to_s]
  if !@lösche_konto.nil?
    if @lösche_konto.authenticated?(params["lösche_pin"])
      konto_manager.delete_konto(params["lösche_konto_nr"])
      konto_manager.store_to_file
      redirect "/"
    else
      @message = "Die angegebene Pin stimmt nicht mit der zugehörigen Kontonummer überein"
      erb :delete_konto
    end
  else
    @message = "Das angegebene Konto ist nicht vorhanden"
    erb :delete_konto
  end
end

# login/logout_konto------------------------------------

get "/login_konto" do
  erb :login_konto
end

post "/login" do
  @konto = konto_manager.konten[params["login_konto_nr"].to_s]
  if !@konto.nil?
    if @konto.authenticated?(params["login_pin"])
      setze_aktuelle_konto(params["login_konto_nr"])
      redirect "/logged_in_index"
    else
      @message = "Ihre Kontonummer und die angegebene Pin stimmen nicht überein"
      erb :login_konto
    end
  else
    @message = "Das angegebene Konto existiert nicht"
    erb :login_konto
  end
end

get "/logout" do
  setze_aktuelle_konto(nil)
  redirect "/"
end

# logged_in_index--------------------------------

get "/logged_in_index" do
  erb :logged_in_index
end

# konto_auszug-----------------------------------

get "/konto_auszug" do
  @kontostand = aktuelle_konto.kontostand
  @konto = aktuelle_konto
  erb :konto_auszug
end

# konto_einzahlen_auszahlen----------------------

get "/konto_einzahlen" do
  erb :konto_einzahlen
end

post "/einzahlen" do
  if params["betrag"].to_i > 0
    aktuelle_konto.add_new_ueberweisung(aktuelle_konto.konto_nr, session[:aktuelle_konto].to_i, params["betrag"].to_i, "EINZAHLUNG")
    aktuelle_konto.ueberweisung_to_csv
    redirect "/logged_in_index"
  else
    @fehler = "Ihre eingabe ware inkorrekt"
    erb :konto_einzahlen
  end
end

get "/konto_auszahlen" do
  erb :konto_auszahlen
end

post "/auszahlen" do
  if params["betrag"].to_i > 0
    aktuelle_konto.add_new_ueberweisung(aktuelle_konto.konto_nr, session[:aktuelle_konto].to_i, -params["betrag"].to_i, "AUSZAHLUNG")
    aktuelle_konto.ueberweisung_to_csv
    redirect "/logged_in_index"
  else
    @fehler = "Ihre eingabe ware inkorrekt"
    erb :konto_auszahlen
  end
end
# konto_überweisung------------------------------

get "/konto_ueberweisen" do
  erb :konto_ueberweisen
end

post "/ueberweisen" do
  if params["betrag"].to_i > 0
    aktuelle_konto.ausgehenede_ueberweisung(params["ziel"], -params["betrag"].to_i, "ÜBERWEISUNG")
    aktuelle_konto.ueberweisung_to_csv
    redirect "/logged_in_index"
  else
    @fehler = "Ihre eingabe ware inkorrekt"
    erb :konto_ueberweisen
  end
end

# konto_pin_ändern-------------------------------

get "/konto_pin_ändern" do
  erb :pin_alt
end

post "/ändere_pin_verification1" do
  if params["pin_alt"] == aktuelle_konto.pin
    erb :pin_neu
  else
    @fehler_msg = "Ihre eingegebene Pin stimmt nicht mit ihrem Konto überein"
    erb :pin_alt
  end
end

post "/ändere_pin_verification2" do
  @pin1 = params["pin_neu1"]
  @pin2 = params["pin_neu2"]
  if @pin1.size == 3 && @pin1 == @pin2
    aktuelle_konto.aendere_pin(@pin1)
    konto_manager.store_to_file
    @neue_pin = @pin1
    erb :pin_verification
  else
    @fehler_msg = "Ihre eingaben stimmen nicht überein oder sind nicht 3-stellig"
    erb :pin_neu
  end
end

# def's------------------------------------------

def aktuelle_konto
  @aktuelle_konto ||=
  if session[:aktuelle_konto]
    konto_manager.konten[session[:aktuelle_konto]]
  end
end

def setze_aktuelle_konto(konto_nr)
  session[:aktuelle_konto] = konto_nr
end

def konto_manager
  @konto_manager ||= KontoManager.new
end
