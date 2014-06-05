require 'sinatra'
require 'csv'
require 'pry'

trans_file = 'bank_data.csv'
accounts_file = 'balances.csv'

def build_transactions(trans_file)
  @transactions = []
  CSV.foreach(trans_file, headers: true) do |row|
    transaction = BankTransaction.new(row["Date"], row["Amount"], row["Description"], row["Account"])
    @transactions << transaction
  end
end

def build_accounts(accounts_file)
  @accounts = []
  CSV.foreach(accounts_file, headers: true) do |row|
    account = BankAccount.new(row["Account"], row["Balance"])
    @accounts << account
  end
end

class BankTransaction
  attr_reader :date, :amount, :description, :account
  def initialize(date, amount, description, account)
    @date = date
    @amount = amount
    @description = description
    @account = account
  end

  def deposit?(amount)
    if @amount.to_i > 0
      true
    else
      false
    end
  end

  def summary
    @string = "#{@date}: #{@account} #{@amount}, #{@description}"
    @string
  end
end

class BankAccount
  attr_reader :account, :balance
  def initialize(account, balance)
    @account = account
    @balance = balance
  end

  def starting_balance
    @balance
  end

  def current_balance
    @amount_trans = []
    build_transactions('bank_data.csv')
    @transactions.each do |transaction|
      if transaction.account == account
        @amount_trans << transaction.amount.to_f
      end
    end
    total = @amount_trans.inject(:+)
    @new_balance = @balance.to_f + total.to_f
    @new_balance
  end

  def summary(account)
    @account_trans = []
    build_transactions('bank_data.csv')
    @transactions.each do |transaction|
      if transaction.account == account
        @account_trans << transaction.summary
      end
    end
    @account_trans
  end
end

get '/' do
  build_transactions(trans_file)
  build_accounts(accounts_file)
  erb :index
end
