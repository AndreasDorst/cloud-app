class LoginService
  attr_reader :params, :session

  def initialize(params, session)
    @params, @session = params, session
  end

  def call
    check_password
    modify_session
    message
  end

  private

  def check_password
    if params[:password] != '123'
      raise ArgumentError, 'Некорректный пароль'
    end
    session[:login] = params[:login]
  end

  def modify_session
    # session[:login] = params[:login]
    session[:balance] ||= 500000 # Устанавливаем баланс, если его нет
  end

  def message
    time = Time.now.hour

    greeting = case time
               when 5..11 then 'Доброе утро'
               when 12..17 then 'Добрый день'
               when 18..22 then 'Добрый вечер'
               else 'Доброй ночи'
               end

    "#{greeting}, #{session[:login]}"
  end
end
  