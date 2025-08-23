$body = @{
    FilePaths = @("C:\Users\SASEN1\Desktop\NNF\1Gb test.txt")
    SearchText = "5886f46c-84a0-412c-b8e8-e55c3ddbd7bd-28"
    MaxMatchesPerFile = 10
} | ConvertTo-Json

$result = Invoke-RestMethod -Uri "https://localhost:7210/api/search" -Method Post -Body $body -ContentType "application/json"

Write-Host "Поиск занял: $($result.ElapsedMilliseconds) мс"
Write-Host ""

foreach ($fileResult in $result.Results) {
    Write-Host "=== Файл: $($fileResult.FilePath) ==="
    if ($fileResult.Error) {
        Write-Host "ОШИБКА: $($fileResult.Error)" -ForegroundColor Red
    } else {
        Write-Host "Найдено: $($fileResult.Matches.Count) совпадений" -ForegroundColor Green
        foreach ($match in $fileResult.Matches) {
            Write-Host "[Строка $($match.LineNumber)] $($match.LineText.Trim())"
        }
    }
    Write-Host ""
}
