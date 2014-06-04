require 'sinatra'
require 'csv'

file = 'bank_data.csv'

def build_data(file)
  @transactions = []
  CSV.foreach(file, headers: true) do |row|
    trans_hash = {}
    trans_hash[:date] = row["Date"]
    trans_hash[:amount] = row["Amount"]
    trans_hash[:description] = row["Description"]
    trans_hash[:account] = row["Account"]
    @transactions << trans_hash
  end
  puts @transactions
end

class BankTransaction

  def deposit?(amount)
    if amount.to_i > 0
      true
    else
      false
    end
  end

  def summary
    #return a string of the transaction
  end

end

class BankAccount

  def starting_balance
    #that returns the starting balance loaded from the file
  end

  def current_balance
    #that returns the ending balance after all transactions have been processed
  end

  def summary
    #that returns an array of all of the transaction summaries
  end

end

get '/' do
  build_data(file)
  erb :index
end

