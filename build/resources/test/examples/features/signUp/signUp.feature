Feature: Registro de un nuevo cliente en DemoBlaze - https://www.demoblaze.com/index.html


  Background:
    * def getPaths = read('classpath:examples/data/getPaths.js')
    * def path = getPaths('signUp')
    * def generarNombreUsuario = read('classpath:examples/data/getRandomUserName.js')
    * def dataRegisteredUser = read('classpath:examples/data/dataRegisteredUser.json')
    * print 'Dominio de Demo Blaze ' , domainURL


  Scenario: Registrar un nuevo cliente exitosamente
    * def username = generarNombreUsuario()
    * print 'Se guardara el usuario con el username ', username
    Given url domainURL + path
    And request { username: '#(username)', password: '#(dataRegisteredUser.user.password)' }
    When method POST
    Then status 200
    * karate.pause(1000)
    Then match karate.response.header('content-type') == 'application/json'
    Then match response == '#string'
    Then match response != 'null'
    And match response contains ""
    And assert responseTime < 5000


  Scenario: Intentar Registrar un cliente ya existente
    Given url domainURL + path
    And request { username: '#(dataRegisteredUser.user.username)', password: '#(dataRegisteredUser.user.password)' }
    When method POST
    * karate.pause(1000)
    Then status 200
    Then match karate.response.header('content-type') == 'application/json'
    Then match response.errorMessage == '#string'
    Then match response.errorMessage != 'null'
    And match response.errorMessage == 'This user already exist.'
    And match response == read('classpath:examples/data/responseUserExist.json')
    And assert responseTime < 5000
