*** Settings ***
Documentation    Test REST Countries API - Search Countries by Name
Resource         ../../resources/common.robot
Test Setup       Setup API Session
Test Teardown    Teardown API Session

*** Test Cases ***
Search Country By Full Name
    [Documentation]    Test searching for a country by full name
    [Tags]    api    countries    search    smoke
    ${response}=    GET On Session    restcountries    /name/germany
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

Search Country By Partial Name
    [Documentation]    Test searching for countries by partial name
    [Tags]    api    countries    search    partial
    ${response}=    GET On Session    restcountries    /name/united
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be True    ${countries_count} >= 2
    
    # Should include United States and United Kingdom
    ${found_us}=    Set Variable    False
    ${found_uk}=    Set Variable    False
    
    FOR    ${country}    IN    @{countries}
        ${name}=    Get From Dictionary    ${country}    name
        ${common_name}=    Get From Dictionary    ${name}    common
        IF    '${common_name}' == 'United States'
            ${found_us}=    Set Variable    True
        ELSE IF    '${common_name}' == 'United Kingdom'
            ${found_uk}=    Set Variable    True
        END
    END
    
    Should Be True    ${found_us}    Should find United States
    Should Be True    ${found_uk}    Should find United Kingdom

Search Non-Existent Country
    [Documentation]    Test searching for a non-existent country
    [Tags]    api    countries    search    negative
    ${response}=    GET On Session    restcountries    /name/nonexistentcountry    expected_status=404
    Should Be Equal As Strings    ${response.status_code}    404
    
    ${error_response}=    Set Variable    ${response.json()}
    Should Contain    ${error_response}    status
    Should Contain    ${error_response}    message
    
    ${status}=    Get From Dictionary    ${error_response}    status
    Should Be Equal As Strings    ${status}    404

Search With Special Characters
    [Documentation]    Test searching for countries with special characters
    [Tags]    api    countries    search    special
    ${response}=    GET On Session    restcountries    /name/ivory
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be True    ${countries_count} >= 1
    
    ${country}=    Get From List    ${countries}    0
    ${name}=    Get From Dictionary    ${country}    name
    ${common_name}=    Get From Dictionary    ${name}    common
    Should Contain    ${common_name}    Ivory

Search Case Insensitive
    [Documentation]    Test case insensitive search
    [Tags]    api    countries    search    case
    ${response_lower}=    GET On Session    restcountries    /name/japan
    ${response_upper}=    GET On Session    restcountries    /name/JAPAN
    ${response_mixed}=    GET On Session    restcountries    /name/JaPaN
    
    Should Be Equal As Strings    ${response_lower.status_code}    200
    Should Be Equal As Strings    ${response_upper.status_code}    200
    Should Be Equal As Strings    ${response_mixed.status_code}    200
    
    ${countries_lower}=    Set Variable    ${response_lower.json()}
    ${countries_upper}=    Set Variable    ${response_upper.json()}
    ${countries_mixed}=    Set Variable    ${response_mixed.json()}
    
    # All should return the same result
    ${count_lower}=    Get Length    ${countries_lower}
    ${count_upper}=    Get Length    ${countries_upper}
    ${count_mixed}=    Get Length    ${countries_mixed}
    
    Should Be Equal As Strings    ${count_lower}    ${count_upper}
    Should Be Equal As Strings    ${count_lower}    ${count_mixed}
    
    ${japan_lower}=    Get From List    ${countries_lower}    0
    ${japan_upper}=    Get From List    ${countries_upper}    0
    ${japan_mixed}=    Get From List    ${countries_mixed}    0
    
    ${name_lower}=    Get From Dictionary    ${japan_lower}    name
    ${name_upper}=    Get From Dictionary    ${japan_upper}    name
    ${name_mixed}=    Get From Dictionary    ${japan_mixed}    name
    
    ${common_lower}=    Get From Dictionary    ${name_lower}    common
    ${common_upper}=    Get From Dictionary    ${name_upper}    common
    ${common_mixed}=    Get From Dictionary    ${name_mixed}    common
    
    Should Be Equal As Strings    ${common_lower}    Japan
    Should Be Equal As Strings    ${common_upper}    Japan
    Should Be Equal As Strings    ${common_mixed}    Japan