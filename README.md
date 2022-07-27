# ProHome Api Client

Простенький клиент для API УК ProHome ( https://prohome.ru/ ).Оборачивать в gem 30 строчек кода лень, хотя может быть и запилю.

Официально ProHome не дает доступа к своему API.

Используйте на свой страх и риск.

## Installation
```ruby
  require 'client'
  client = ProHome::Api::Client.new
```
## Usage
Подавляющее большинство методов API используют POST-запросы для получения параметров.
Для авторизации используется Bearer.

### Как получить Bearer?
Поочередно дернуть методы registration и codeconfirm ( передаваемые параметры описаны ниже).
Обязательным условием является наличие Вас в базе ProHome.

## Методы API
  API имеет довольно много методов, опишу пока только процесс регистрации и получения первичных данных.
  В дальнейшем дополню описание другими методами.

### registration
Регистрация в приложении.
Как писалось выше - эти данные должны быть у ProHome.

Параметры:
```ruby
  params = { "FName": "Петр",
             "MName": "Иванович",
             "LName": "ПроХомов",
             "Phone": "79031234567" }
  client.registration(data: params)
```
В случае success на телефон в виде SMS будет выслан код подтверждения.

Ответ:
```ruby
  {"success"=>true, "message"=>"OK", "details"=>nil, "data"=>nil}
```

### codeconfirm
Подтверждение. В data будет содержаться Bearer, который в дальнейшем должен использоваться в заголовках.
А так же 

Параметры:
```ruby
  params = { "FName": "Петр",
             "MName": "Иванович",
             "LName": "ПроХомов",
             "Code":  "1234",
             "Phone": "79031234567" }
  client.codeconfirm(data: params)
```

Ответ:
```ruby
{"success"=>true, "message"=>"OK", "details"=>nil, "data"=>{"ClientID"=>"xxxx-xxxx-xxxx-xxxx-xxxx", "Token"=>{"AccessToken"=>"xxxxxxx", "RefreshToken"=>"xxxxxxxx", "ExpiresIn"=>3600, "TokenType"=>"Bearer"}}}
```
### counter
Возвращает текущее значение счетчиков за текущий отчетный период,

Параметры:
```ruby
  params = {"ClientID": "ClientID, полученный в ответе метода codeconfirm",
            "PersonalAccountNumber": "см dependencies['Dependencies']['PersonalAccount']['Number']" }
  client.counters(data: params)
```

### counters_history
Возвращает значения счетчиков помесячно за выбранный период. Обратите внимание на формат даты + ОБЯЗАТЕЛЬНОЕ наличие времени.

Параметры:
```ruby
  params = {"ClientID": "ClientID, полученный в ответе метода codeconfirm",
            "PersonalAccountNumber": "см dependencies['Dependencies']['PersonalAccount']['Number']",
            "StartDate": '01.01.2010 00:00:00',
            "EndDate": '01.01.2022 00:00:00'}
  client.counters_history(data: params)
```

### dependencies
Метод возвращает набор данных, необходимых при дальнейшей работе с API.

Параметры:
```ruby
  params = {"ClientID": "ClientID, полученный в ответе метода codeconfirm"
  client.dependencies(data: params)
```

Ответ:
```ruby
{
  "Gender": "мужской",
  "Email": "remember@cadia.ru",
  "FirstName": "Иван",
  "LastName": "Петрович",
  "MiddleName": "ПроХомов",
  "Telephone": null,
  "MobilePhone": "79031234567",
  "EmailConfirmed": true,
  "ActiveOSS": false,
  "ShowOSSNotification": true,
  "Dependencies": [
    {
      "PersonalAccount": {
        "Suspended": null,
        "Subsidy": null,
        "Created": "2018-11-19T21:03:00+00:00",
        "LastPaymentDate": "2022-01-01T00:00:00+03:00",
        "LastPaymentAmount": 12345,
        "Balance": 0,
        "OverdueDebt": 12345.74,
        "Number": "0123456789",
        "EstateObject": {
          "Floor": 2,
          "NumberOnFloor": 1,
          "Address": "Москва, ул. Красная Площадь, д.1",
          "AddressExtended": {
            "BuildAddress": "Москва, ул. Красная Площадь, д.1, вл. 1/9, корп. Д21",
            "IntegrationId": "xxxx-xxxx-xxxx-xxxx-xxxx",
            "Name": "Москва, ул. Красная Площадь",
            "PostalAddress": "Москва, ул. Красная Площадь",
            "Id": "xxxx-xxxx-xxxx-xxxx-xxxx",
            "EntityLogicalName": "new_building"
          },
          "IntegrationId": "xxxx-xxxx-xxxx-xxxx-xxxx",
          "Name": "УК Жилищник-1-2-3-кв-19       ",
          "SubType": "Квартира",
          "Type": "Жилое",
          "SaleScheme": null,
          "Project": {
            "IntegrationId": "xxxx-xxxx-xxxx-xxxx-xxxx",
            "Name": "УК Жилищник",
            "IconFilename": "жилищник1.png",
            "HasPassService": false,
            "Id": "xxxx-xxxx-xxxx-xxxx-xxxx",
            "EntityLogicalName": "new_project"
          },
          "Entrance": "1",
          "Building": "Феодосийская, вл. 1/9, корп. Д1",
          "Id": "xxxx-xxxx-xxxx-xxxx-xxxx",
          "EntityLogicalName": "new_estate_object"
        },
        "ClientId": "4xxxx-xxxx-xxxx-xxxx-xxxx",
        "ClientName": "ПроХомов, Петр Иванович",
        "Id": "xxxx-xxxx-xxxx-xxxx-xxxx",
        "EntityLogicalName": "new_personal_account"
      },
      "Role": "Собственник",
      "Incidents": true,
      "Counters": true,
      "Payments": true,
      "registrationNumber": null,
      "share": null,
      "Id": "xxxx-xxxx-xxxx-xxxx-xxxx",
      "EntityLogicalName": "new_contact_relationship"
    }
  ],
  "Id": "xxxx-xxxx-xxxx-xxxx-xxxx",
  "EntityLogicalName": "contact"
}
```