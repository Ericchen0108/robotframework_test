*** Settings ***
Documentation    Test REST Countries API - Get Countries by Country Code
Resource         ../../resources/common.robot
Test Setup       Setup API Session
Test Teardown    Teardown API Session

*** Test Cases ***
Get Country By Alpha2 Code
    [Documentation]    Test getting country by 2-letter country code
    [Tags]    api    countries    code    alpha2    smoke
    ${response}=    GET On Session    restcountries    /alpha/de
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be Equal As Strings    ${countries_count}    1
    
    ${germany}=    Get From List    ${countries}    0
    ${name}=    Get From Dictionary    ${germany}    name
    ${common_name}=    Get From Dictionary    ${name}    common
    Should Be Equal As Strings    ${common_name}    Germany
    
    ${cca2}=    Get From Dictionary    ${germany}    cca2
    Should Be Equal As Strings    ${cca2}    DE
    
    ${cca3}=    Get From Dictionary    ${germany}    cca3
    Should Be Equal As Strings    ${cca3}    DEU

Get Country By Alpha3 Code
    [Documentation]    Test getting country by 3-letter country code
    [Tags]    api    countries    code    alpha3
    ${response}=    GET On Session    restcountries    /alpha/usa
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be Equal As Strings    ${countries_count}    1
    
    ${usa}=    Get From List    ${countries}    0
    ${name}=    Get From Dictionary    ${usa}    name
    ${common_name}=    Get From Dictionary    ${name}    common
    Should Be Equal As Strings    ${common_name}    United States
    
    ${cca2}=    Get From Dictionary    ${usa}    cca2
    Should Be Equal As Strings    ${cca2}    US
    
    ${cca3}=    Get From Dictionary    ${usa}    cca3
    Should Be Equal As Strings    ${cca3}    USA

Get Multiple Countries By Codes
    [Documentation]    Test getting multiple countries by comma-separated codes
    [Tags]    api    countries    code    multiple
    ${response}=    GET On Session    restcountries    /alpha    params=codes=fr,it,es
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be Equal As Strings    ${countries_count}    3
    
    # Verify we get France, Italy, and Spain
    ${found_france}=    Set Variable    False
    ${found_italy}=     Set Variable    False
    ${found_spain}=     Set Variable    False
    
    FOR    ${country}    IN    @{countries}
        ${name}=    Get From Dictionary    ${country}    name
        ${common_name}=    Get From Dictionary    ${name}    common
        
        IF    '${common_name}' == 'France'
            ${found_france}=    Set Variable    True
            ${cca2}=    Get From Dictionary    ${country}    cca2
            Should Be Equal As Strings    ${cca2}    FR
        ELSE IF    '${common_name}' == 'Italy'
            ${found_italy}=    Set Variable    True
            ${cca2}=    Get From Dictionary    ${country}    cca2
            Should Be Equal As Strings    ${cca2}    IT
        ELSE IF    '${common_name}' == 'Spain'
            ${found_spain}=    Set Variable    True
            ${cca2}=    Get From Dictionary    ${country}    cca2
            Should Be Equal As Strings    ${cca2}    ES
        END
    END
    
    Should Be True    ${found_france}    Should find France
    Should Be True    ${found_italy}     Should find Italy
    Should Be True    ${found_spain}     Should find Spain

Get Country By Invalid Code
    [Documentation]    Test getting country with invalid country code
    [Tags]    api    countries    code    negative
    ${response}=    GET On Session    restcountries    /alpha/xyz    expected_status=404
    Should Be Equal As Strings    ${response.status_code}    404
    
    ${error_response}=    Set Variable    ${response.json()}
    Should Contain    ${error_response}    status
    Should Contain    ${error_response}    message
    
    ${status}=    Get From Dictionary    ${error_response}    status
    Should Be Equal As Strings    ${status}    404

Verify Country Code Consistency
    [Documentation]    Test consistency between different country code formats
    [Tags]    api    countries    code    consistency
    # Get country by alpha2 code
    ${response_alpha2}=    GET On Session    restcountries    /alpha/jp
    Should Be Equal As Strings    ${response_alpha2.status_code}    200
    
    # Get country by alpha3 code
    ${response_alpha3}=    GET On Session    restcountries    /alpha/jpn
    Should Be Equal As Strings    ${response_alpha3.status_code}    200
    
    ${country_alpha2}=    Get From List    ${response_alpha2.json()}    0
    ${country_alpha3}=    Get From List    ${response_alpha3.json()}    0
    
    # Both should return the same country (Japan)
    ${name_alpha2}=    Get From Dictionary    ${country_alpha2}    name
    ${name_alpha3}=    Get From Dictionary    ${country_alpha3}    name
    
    ${common_name_alpha2}=    Get From Dictionary    ${name_alpha2}    common
    ${common_name_alpha3}=    Get From Dictionary    ${name_alpha3}    common
    
    Should Be Equal As Strings    ${common_name_alpha2}    Japan
    Should Be Equal As Strings    ${common_name_alpha3}    Japan
    Should Be Equal As Strings    ${common_name_alpha2}    ${common_name_alpha3}
    
    # Verify codes are consistent
    ${cca2_from_alpha2}=    Get From Dictionary    ${country_alpha2}    cca2
    ${cca2_from_alpha3}=    Get From Dictionary    ${country_alpha3}    cca2
    Should Be Equal As Strings    ${cca2_from_alpha2}    JP
    Should Be Equal As Strings    ${cca2_from_alpha3}    JP
    
    ${cca3_from_alpha2}=    Get From Dictionary    ${country_alpha2}    cca3
    ${cca3_from_alpha3}=    Get From Dictionary    ${country_alpha3}    cca3
    Should Be Equal As Strings    ${cca3_from_alpha2}    JPN
    Should Be Equal As Strings    ${cca3_from_alpha3}    JPN

Test Case Sensitivity For Codes
    [Documentation]    Test that country codes are case insensitive
    [Tags]    api    countries    code    case
    ${response_lower}=    GET On Session    restcountries    /alpha/ca
    ${response_upper}=    GET On Session    restcountries    /alpha/CA
    ${response_mixed}=    GET On Session    restcountries    /alpha/Ca
    
    Should Be Equal As Strings    ${response_lower.status_code}    200
    Should Be Equal As Strings    ${response_upper.status_code}    200
    Should Be Equal As Strings    ${response_mixed.status_code}    200
    
    ${country_lower}=    Get From List    ${response_lower.json()}    0
    ${country_upper}=    Get From List    ${response_upper.json()}    0
    ${country_mixed}=    Get From List    ${response_mixed.json()}    0
    
    # All should return Canada
    ${name_lower}=    Get From Dictionary    ${country_lower}    name
    ${name_upper}=    Get From Dictionary    ${country_upper}    name
    ${name_mixed}=    Get From Dictionary    ${country_mixed}    name
    
    ${common_lower}=    Get From Dictionary    ${name_lower}    common
    ${common_upper}=    Get From Dictionary    ${name_upper}    common
    ${common_mixed}=    Get From Dictionary    ${name_mixed}    common
    
    Should Be Equal As Strings    ${common_lower}    Canada
    Should Be Equal As Strings    ${common_upper}    Canada
    Should Be Equal As Strings    ${common_mixed}    Canada