Feature: Login de un cliente en DemoBlaze - https://www.demoblaze.com/index.html


  Background:
    * def getPaths = read('classpath:examples/data/getPaths.js')
    * def path = getPaths('login')
    * def dataRegisteredUser = read('classpath:examples/data/dataRegisteredUser.json')
    * print 'Dominio de Demo Blaze ' , domainURL


  Scenario: LOGIN de un Cliente exitosamente con CREDENCIALES CORRECTAS
    Given url domainURL + path
    And request { username: '#(dataRegisteredUser.user.username)', password: '#(dataRegisteredUser.user.passwordEncripted)' }
    When method POST
    Then status 200
    * karate.pause(1000)
    Then match karate.response.header('content-type') == 'application/json'
    Then match response == "#string"
    Then match response != 'null'
    And match response contains 'Auth_token:'
    And assert responseTime < 5000

  Scenario: Intentar LOGIN de un Cliente con USERNAME que no EXISTE
    Given url domainURL + path
    And request { username: '#(dataRegisteredUser.user.failUsername)', password: '#(dataRegisteredUser.user.password)' }
    When method POST
    * karate.pause(1000)
    Then status 200
    Then match karate.response.header('content-type') == 'application/json'
    Then match response.errorMessage == '#string'
    Then match response.errorMessage != 'null'
    And match response.errorMessage == 'User does not exist.'
    And match response == read('classpath:examples/data/responseUserNotExist.json')
    And assert responseTime < 5000


  Scenario: Intentar LOGIN de un Cliente con CONTRASEÑA INCORRECTA
    Given url domainURL + path
    And request { username: '#(dataRegisteredUser.user.username)', password: '#(dataRegisteredUser.user.failPassword)' }
    When method POST
    * karate.pause(1000)
    Then status 200
    Then match karate.response.header('content-type') == 'application/json'
    Then match response.errorMessage == '#string'
    Then match response.errorMessage != 'null'
    And match response.errorMessage == 'Wrong password.'
    And match response == read('classpath:examples/data/responseWrongPassword.json')
    And assert responseTime < 5000
