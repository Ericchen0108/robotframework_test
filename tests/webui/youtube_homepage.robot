*** Settings ***
Documentation    Test YouTube homepage basic functionality
Resource         ../../resources/common.robot
Test Setup       Open YouTube
Test Teardown    Close YouTube

*** Test Cases ***
Load YouTube Homepage
    [Documentation]    Test that YouTube homepage loads successfully
    [Tags]    webui    homepage    smoke
    ${title}=    Get Title
    Should Contain    ${title}    YouTube    ignore_case=True
    
    # Verify page loaded properly
    Page Should Contain    YouTube
    
    # Check that basic page elements exist
    ${page_source}=    Get Source
    Should Contain    ${page_source}    YouTube
    Should Contain    ${page_source}    html

YouTube Search Test
    [Documentation]    Test YouTube search functionality
    [Tags]    webui    search    smoke
    # Wait for search input to be available
    Wait Until Element Is Visible    css:input.ytSearchboxComponentInput    timeout=10s
    
    # Enter search term
    Input Text    css:input.ytSearchboxComponentInput    robot framework
    
    # Click search button
    Click Element    css:button.ytSearchboxComponentSearchButton
    
    # Wait for results page to load
    Wait Until Location Contains    /results    timeout=10s
    
    # Verify search results page loaded
    ${current_url}=    Get Location
    Should Contain    ${current_url}    /results
    Should Contain    ${current_url}    robot+framework