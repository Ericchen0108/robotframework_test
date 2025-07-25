*** Settings ***
Documentation    Test REST Countries API - Get All Countries
Resource         ../../resources/common.robot
Test Setup       Setup API Session
Test Teardown    Teardown API Session

*** Test Cases ***
Get All Countries
    [Documentation]    Test retrieving all countries from REST Countries API
    [Tags]    api    countries    all    smoke
    ${response}=    GET On Session    restcountries    /all    params=fields=name,cca2,cca3,region,subregion,population
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${countries}
    Should Be True    ${countries_count} > 190
    
    # Verify first country has required fields
    ${first_country}=    Get From List    ${countries}    0
    Should Contain    ${first_country}    name
    Should Contain    ${first_country}    cca2
    Should Contain    ${first_country}    cca3
    Should Contain    ${first_country}    region
    
    ${name}=    Get From Dictionary    ${first_country}    name
    Should Contain    ${name}    common
    Should Contain    ${name}    official

Verify Country Data Structure
    [Documentation]    Test country data structure and required fields
    [Tags]    api    countries    structure
    ${response}=    GET On Session    restcountries    /all    params=fields=name,cca2,cca3,region,subregion
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    
    # Test first 10 countries for consistency
    FOR    ${i}    IN RANGE    10
        ${country}=    Get From List    ${countries}    ${i}
        
        # Required fields validation
        Should Contain    ${country}    name
        Should Contain    ${country}    cca2
        Should Contain    ${country}    cca3
        Should Contain    ${country}    region
        Should Contain    ${country}    subregion
        
        # Validate name structure
        ${name}=    Get From Dictionary    ${country}    name
        Should Contain    ${name}    common
        Should Contain    ${name}    official
        
        # Validate codes
        ${cca2}=    Get From Dictionary    ${country}    cca2
        ${cca2_length}=    Get Length    ${cca2}
        Should Be Equal As Strings    ${cca2_length}    2
        
        ${cca3}=    Get From Dictionary    ${country}    cca3
        ${cca3_length}=    Get Length    ${cca3}
        Should Be Equal As Strings    ${cca3_length}    3
    END

Test Response Performance
    [Documentation]    Test API response time for all countries
    [Tags]    api    countries    performance
    ${start_time}=    Get Time    epoch
    ${response}=    GET On Session    restcountries    /all    params=fields=name,region
    ${end_time}=    Get Time    epoch
    
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${response_time}=    Evaluate    ${end_time} - ${start_time}
    Should Be True    ${response_time} < 10    Response time should be less than 10 seconds

Verify Regional Distribution
    [Documentation]    Test regional distribution of countries
    [Tags]    api    countries    regions
    ${response}=    GET On Session    restcountries    /all    params=fields=name,region
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${countries}=    Set Variable    ${response.json()}
    ${regions}=    Create Dictionary
    
    FOR    ${country}    IN    @{countries}
        ${region}=    Get From Dictionary    ${country}    region
        ${count}=    Get From Dictionary    ${regions}    ${region}    default=0
        ${new_count}=    Evaluate    ${count} + 1
        Set To Dictionary    ${regions}    ${region}    ${new_count}
    END
    
    # Verify major regions exist
    Should Contain    ${regions}    Africa
    Should Contain    ${regions}    Asia
    Should Contain    ${regions}    Europe
    Should Contain    ${regions}    Americas
    Should Contain    ${regions}    Oceania
    
    # Verify reasonable country counts per region
    ${africa_count}=    Get From Dictionary    ${regions}    Africa
    Should Be True    ${africa_count} > 40
    
    ${asia_count}=    Get From Dictionary    ${regions}    Asia
    Should Be True    ${asia_count} > 35

Test Content Type and Headers
    [Documentation]    Test response headers and content type
    [Tags]    api    countries    headers
    ${response}=    GET On Session    restcountries    /all    params=fields=name,region
    Should Be Equal As Strings    ${response.status_code}    200
    
    # Verify content type
    ${content_type}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Contain    ${content_type}    application/json
    
    # Verify response has proper encoding
    Should Contain    ${response.headers}    Content-Length
    
    # Verify response has data
    ${json_response}=    Set Variable    ${response.json()}
    ${countries_count}=    Get Length    ${json_response}
    Should Be True    ${countries_count} > 100    Response should contain substantial data