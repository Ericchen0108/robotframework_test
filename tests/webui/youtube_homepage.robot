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