@{
    ExcludeRules = @(
        'PSAvoidUsingWriteHost'
    )

    Rules = @{
        PSAvoidUsingCmdletAliases = @{
            AllowList = @(
                'select', 'where'
            )
        }
    }

}
