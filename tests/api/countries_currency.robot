*** Settings ***
Documentation    Test REST Countries API - Get Countries by Currency
Resource         ../../resources/common.robot
Test Setup       Setup API Session
Test Teardown    Teardown API Session

*** Test Cases ***
Get Countries By Currency USD
    [Documentation]    Test getting countries that use USD currency
    [Tags]    api    countries    currency    usd    smoke
    ${response}=    GET On Session    restcountries    /currency/usd
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be True    ${countries_count} >= 5
    
    # Verify all returned countries use USD
    ${found_usa}=    Set Variable    False
    
    FOR    ${country}    IN    @{countries}
        # Check if country has currencies field
        ${has_currencies}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${country}    currencies
        IF    ${has_currencies}
            ${currencies}=    Get From Dictionary    ${country}    currencies
            Should Contain    ${currencies}    USD
            
            ${name}=    Get From Dictionary    ${country}    name
            ${common_name}=    Get From Dictionary    ${name}    common
            IF    '${common_name}' == 'United States'
                ${found_usa}=    Set Variable    True
            END
        END
    END
    
    Should Be True    ${found_usa}    Should find United States using USD

Get Countries By Currency EUR
    [Documentation]    Test getting countries that use EUR currency
    [Tags]    api    countries    currency    eur
    ${response}=    GET On Session    restcountries    /currency/eur
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be True    ${countries_count} >= 15
    
    # Check for specific EUR countries
    ${found_germany}=    Set Variable    False
    ${found_france}=     Set Variable    False
    ${found_italy}=      Set Variable    False
    
    FOR    ${country}    IN    @{countries}
        ${name}=    Get From Dictionary    ${country}    name
        ${common_name}=    Get From Dictionary    ${name}    common
        
        # Verify currency
        ${has_currencies}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${country}    currencies
        IF    ${has_currencies}
            ${currencies}=    Get From Dictionary    ${country}    currencies
            Should Contain    ${currencies}    EUR
        END
        
        IF    '${common_name}' == 'Germany'
            ${found_germany}=    Set Variable    True
        ELSE IF    '${common_name}' == 'France'
            ${found_france}=    Set Variable    True
        ELSE IF    '${common_name}' == 'Italy'
            ${found_italy}=    Set Variable    True
        END
    END
    
    Should Be True    ${found_germany}    Should find Germany using EUR
    Should Be True    ${found_france}     Should find France using EUR
    Should Be True    ${found_italy}      Should find Italy using EUR

Get Countries By Currency GBP
    [Documentation]    Test getting countries that use GBP currency
    [Tags]    api    countries    currency    gbp
    ${response}=    GET On Session    restcountries    /currency/gbp
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be True    ${countries_count} >= 1
    
    # Should include United Kingdom
    ${found_uk}=    Set Variable    False
    
    FOR    ${country}    IN    @{countries}
        ${name}=    Get From Dictionary    ${country}    name
        ${common_name}=    Get From Dictionary    ${name}    common
        
        # Verify currency
        ${has_currencies}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${country}    currencies
        IF    ${has_currencies}
            ${currencies}=    Get From Dictionary    ${country}    currencies
            Should Contain    ${currencies}    GBP
        END
        
        IF    '${common_name}' == 'United Kingdom'
            ${found_uk}=    Set Variable    True
        END
    END
    
    Should Be True    ${found_uk}    Should find United Kingdom using GBP

Get Countries By Invalid Currency
    [Documentation]    Test getting countries with invalid currency code
    [Tags]    api    countries    currency    negative
    ${response}=    GET On Session    restcountries    /currency/invalidcurrency    expected_status=404
    Should Be Equal As Strings    ${response.status_code}    404
    
    ${error_response}=    Set Variable    ${response.json()}
    Should Contain    ${error_response}    status
    Should Contain    ${error_response}    message
    
    ${status}=    Get From Dictionary    ${error_response}    status
    Should Be Equal As Strings    ${status}    404

Verify Currency Data Structure
    [Documentation]    Test currency data structure in country response
    [Tags]    api    countries    currency    structure
    ${response}=    GET On Session    restcountries    /currency/jpy
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be True    ${countries_count} >= 1
    
    # Find Japan and verify currency structure
    FOR    ${country}    IN    @{countries}
        ${name}=    Get From Dictionary    ${country}    name
        ${common_name}=    Get From Dictionary    ${name}    common
        
        IF    '${common_name}' == 'Japan'
            ${has_currencies}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${country}    currencies
            Should Be True    ${has_currencies}
            
            ${currencies}=    Get From Dictionary    ${country}    currencies
            Should Contain    ${currencies}    JPY
            
            ${jpy_info}=    Get From Dictionary    ${currencies}    JPY
            Should Contain    ${jpy_info}    name
            Should Contain    ${jpy_info}    symbol
            
            ${currency_name}=    Get From Dictionary    ${jpy_info}    name
            Should Be Equal As Strings    ${currency_name}    Japanese yen
            
            ${currency_symbol}=    Get From Dictionary    ${jpy_info}    symbol
            Should Be Equal As Strings    ${currency_symbol}    ¥
            
            BREAK
        END
    END