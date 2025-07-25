*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary
Library    Collections
Library    String
Library    OperatingSystem

*** Variables ***
${BROWSER}              chrome
${DELAY}                1
${YOUTUBE_URL}          https://www.youtube.com
${REST_COUNTRIES_URL}   https://restcountries.com/v3.1

*** Keywords ***
Open YouTube
    Open Browser    ${YOUTUBE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}

Close YouTube
    Close Browser

Wait For Element And Click
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Click Element    ${locator}

Wait For Element And Type
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Input Text    ${locator}    ${text}

Setup API Session
    Create Session    restcountries    ${REST_COUNTRIES_URL}
    
Teardown API Session
    Delete All Sessions