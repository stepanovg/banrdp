#file data base
[string] $DBFullName = ".\ipdb.txt"
Function Add-BanRDP {
    param(
    # Parameter help description
        [Parameter(Mandatory=$True, 
            HelpMessage="IP address is ruquired.")]
        [string] $IPAddress,
        
        [Parameter (Mandatory=$False)]
        [string] $UserName
    )
    
    $TmpHashKey = $IPAddress;
    $TmpHashData = @{DateTime=@(Get-Date); UserName = @($UserName); Blocked=$False}
    $TmpHash = @{$TmpHashKey = $TmpHashData}
    $IPDB = Get-BanRDPDB;

    if (!$IPDB) {
        $IPDB = @{}
        $IPDB += $TmpHash
    } else {
        if ($IPDB.Contains($IPAddress)){
            $IPDB.$IPAddress += $TmpHashData
        } else {
            $IPDB += $TmpHash
        }
    }
    
    #save db to file
    $IPDB | ConvertTo-Json | Set-Content -Path $DBFullName
    
    
    Write-Host $TmpHash;
}
Function Get-BanRDPDB{
    $DBData = ""
    if (Test-Path $DBFullName){
        $DBData = Get-Content -Path $DBFullName | ConvertFrom-Json
    } else {
        Write-Host "DB not found."
    }
    return $DBData;
}