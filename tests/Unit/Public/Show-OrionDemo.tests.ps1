BeforeAll {
    $script:dscModuleName = 'OrionDesign'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Get-Something {
    BeforeAll {
        Mock -CommandName Get-PrivateFunction -MockWith {
            # This return the value passed to the Get-PrivateFunction parameter $PrivateData.
            $PrivateData
        } -ModuleName $dscModuleName
    }

    Context 'When tested, skip for now' {
        It 'Should skip the test' -Skip {
            #No test yet
        }
    }

}

