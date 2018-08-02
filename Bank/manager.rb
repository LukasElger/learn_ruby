class Manager
  def initialize
    login_screen
  end

  def login_screen
    puts "Willkommen im Login-Screen..."
    puts "Wählen sie eine der folgenden Aktionen:"
    puts "1. Mit bestehendem Konto einloggen"
    puts "2. Konto erstellen"
    puts "3. Login verlassen"

    action = gets.chomp

    if action.to_i == 1
      return login
    elsif action.to_i == 2
      return create
    elsif action.to_i == 3
      puts "Sie haben den Login-Screen erfolgreich verlassen."
    else
      puts "Das ist keine gültige Eingabe."
      return login_screen
    end
  end

  def interface

    puts "Wählen sie eine der folgenden Aktionen:"
    puts "1. Geld einzahlen"
    puts "2. Geld auszahlen"
    puts "3. Konto löschen"
    puts "4. Interface verlassen"

    action = gets.chomp

    if action.to_i == 1
      return input
    elsif action.to_i == 2
      return output
    elsif action.to_i == 3
      return delete
    elsif action.to_i == 4
      puts "Sie haben das Interface erfolgreich verlassen."
      return login_screen
    else
      puts "Das ist keine gültige Eingabe."
      return interface
    end

  end

  def login

  end

  def create
    puts "Geben sie eine Kontonummer ein:"
    @konto_nr = gets.chomp

  end

  def delete

  end

  def input
    puts "Geben sie den einzuzahlenden Betrag ein:"
    betrag = gets.chomp
    @kontostand += betrag
    puts "Sie haben erfolgreich #{betrag}€ eingezahlt."
  end

  def output
    puts "Geben sie den auszuzahlenden Betrag ein:"
    betrag = gets.chomp
    if (@kontostand - betrag) <= 0
      puts "Du hast zu wenig Geld auf deinem Konto."
    else
      @kontostand -= betrag
      puts "Sie haben erfolgreich #{betrag}€ ausgezahlt."
  end
  return interface
end
