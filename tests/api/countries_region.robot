*** Settings ***
Documentation    Test REST Countries API - Get Countries by Region
Resource         ../../resources/common.robot
Test Setup       Setup API Session
Test Teardown    Teardown API Session

*** Test Cases ***
Get Countries By Region Europe
    [Documentation]    Test getting all European countries
    [Tags]    api    countries    region    europe    smoke
    ${response}=    GET On Session    restcountries    /region/europe
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be True    ${countries_count} > 40
    
    # Verify all returned countries are in Europe
    FOR    ${country}    IN    @{countries}
        ${region}=    Get From Dictionary    ${country}    region
        Should Be Equal As Strings    ${region}    Europe
    END
    
    # Check for specific European countries
    ${found_germany}=    Set Variable    False
    ${found_france}=    Set Variable    False
    ${found_italy}=    Set Variable    False
    
    FOR    ${country}    IN    @{countries}
        ${name}=    Get From Dictionary    ${country}    name
        ${common_name}=    Get From Dictionary    ${name}    common
        IF    '${common_name}' == 'Germany'
            ${found_germany}=    Set Variable    True
        ELSE IF    '${common_name}' == 'France'
            ${found_france}=    Set Variable    True
        ELSE IF    '${common_name}' == 'Italy'
            ${found_italy}=    Set Variable    True
        END
    END
    
    Should Be True    ${found_germany}    Should find Germany in Europe
    Should Be True    ${found_france}     Should find France in Europe
    Should Be True    ${found_italy}      Should find Italy in Europe

Get Countries By Region Asia
    [Documentation]    Test getting all Asian countries
    [Tags]    api    countries    region    asia
    ${response}=    GET On Session    restcountries    /region/asia
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be True    ${countries_count} > 35
    
    # Verify all returned countries are in Asia
    FOR    ${country}    IN    @{countries}
        ${region}=    Get From Dictionary    ${country}    region
        Should Be Equal As Strings    ${region}    Asia
    END
    
    # Check for specific Asian countries
    ${found_china}=    Set Variable    False
    ${found_japan}=    Set Variable    False
    ${found_india}=    Set Variable    False
    
    FOR    ${country}    IN    @{countries}
        ${name}=    Get From Dictionary    ${country}    name
        ${common_name}=    Get From Dictionary    ${name}    common
        IF    '${common_name}' == 'China'
            ${found_china}=    Set Variable    True
        ELSE IF    '${common_name}' == 'Japan'
            ${found_japan}=    Set Variable    True
        ELSE IF    '${common_name}' == 'India'
            ${found_india}=    Set Variable    True
        END
    END
    
    Should Be True    ${found_china}    Should find China in Asia
    Should Be True    ${found_japan}    Should find Japan in Asia
    Should Be True    ${found_india}    Should find India in Asia

Get Countries By Region Africa
    [Documentation]    Test getting all African countries
    [Tags]    api    countries    region    africa
    ${response}=    GET On Session    restcountries    /region/africa
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be True    ${countries_count} > 50
    
    # Verify all returned countries are in Africa
    FOR    ${country}    IN    @{countries}
        ${region}=    Get From Dictionary    ${country}    region
        Should Be Equal As Strings    ${region}    Africa
    END
    
    # Check for specific African countries
    ${found_nigeria}=    Set Variable    False
    ${found_egypt}=    Set Variable    False
    ${found_south_africa}=    Set Variable    False
    
    FOR    ${country}    IN    @{countries}
        ${name}=    Get From Dictionary    ${country}    name
        ${common_name}=    Get From Dictionary    ${name}    common
        IF    '${common_name}' == 'Nigeria'
            ${found_nigeria}=    Set Variable    True
        ELSE IF    '${common_name}' == 'Egypt'
            ${found_egypt}=    Set Variable    True
        ELSE IF    '${common_name}' == 'South Africa'
            ${found_south_africa}=    Set Variable    True
        END
    END
    
    Should Be True    ${found_nigeria}        Should find Nigeria in Africa
    Should Be True    ${found_egypt}          Should find Egypt in Africa
    Should Be True    ${found_south_africa}   Should find South Africa in Africa

Get Countries By Invalid Region
    [Documentation]    Test getting countries from invalid region
    [Tags]    api    countries    region    negative
    ${response}=    GET On Session    restcountries    /region/invalidregion    expected_status=404
    Should Be Equal As Strings    ${response.status_code}    404
    
    ${error_response}=    Set Variable    ${response.json()}
    Should Contain    ${error_response}    status
    Should Contain    ${error_response}    message
    
    ${status}=    Get From Dictionary    ${error_response}    status
    Should Be Equal As Strings    ${status}    404

Compare Region Population
    [Documentation]    Test comparing population data across regions
    [Tags]    api    countries    region    population
    ${response_asia}=      GET On Session    restcountries    /region/asia
    ${response_europe}=    GET On Session    restcountries    /region/europe
    
    Should Be Equal As Strings    ${response_asia.status_code}    200
    Should Be Equal As Strings    ${response_europe.status_code}    200
    
    ${asia_countries}=    Set Variable    ${response_asia.json()}
    ${europe_countries}=  Set Variable    ${response_europe.json()}
    
    ${asia_total_population}=    Set Variable    0
    ${europe_total_population}=  Set Variable    0
    
    # Calculate total population for Asia
    FOR    ${country}    IN    @{asia_countries}
        ${has_population}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${country}    population
        IF    ${has_population}
            ${population}=    Get From Dictionary    ${country}    population
            ${asia_total_population}=    Evaluate    ${asia_total_population} + ${population}
        END
    END
    
    # Calculate total population for Europe
    FOR    ${country}    IN    @{europe_countries}
        ${has_population}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${country}    population
        IF    ${has_population}
            ${population}=    Get From Dictionary    ${country}    population
            ${europe_total_population}=    Evaluate    ${europe_total_population} + ${population}
        END
    END
    
    # Asia should have larger population than Europe
    Should Be True    ${asia_total_population} > ${europe_total_population}
    Should Be True    ${asia_total_population} > 4000000000    Asia should have over 4 billion people
    Should Be True    ${europe_total_population} > 700000000   Europe should have over 700 million people