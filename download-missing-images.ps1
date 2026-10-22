# Downloads the images + CV that were hosted on Brizy (not in the saved-page zip).
# Run from the project folder in the VS Code terminal:
#   powershell -ExecutionPolicy Bypass -File .\download-missing-images.ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-Location -Path $PSScriptRoot
$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"
$headers = @{ "Referer" = "https://dikdik37892d5a.brizy.site/"; "Accept" = "image/webp,image/*,*/*" }
# each item: destination, then one or more URLs to try in order
$files = @(
  @("images/favicon.png", @("https://cloud-1de12d.becdn.net/images/cropped-favicon-192x192.png")),
  @("images/branded-gradient-background.webp", @("https://cloud-1de12d.becdn.net/media/original/ad3e7e87b0b2197b286efdafbfdc628d/Branded-gradient-background.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/ad3e7e87b0b2197b286efdafbfdc628d/Branded-gradient-background.webp")),
  @("files/laura-crowley-cv.pdf", @("https://cloud-1de12d.becdn.net/media/original/a3a9481c8f04fa53bfed711f7a245cfa.pdf")),
  @("images/projects/this-is-nima.webp", @("https://cloud-1de12d.becdn.net/media/original/435e6fd4d02188ae65fee9ff5805dcc6/screencapture-thisisnima-mystagingwebsite-2025-11-19-21-26-26.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/435e6fd4d02188ae65fee9ff5805dcc6/screencapture-thisisnima-mystagingwebsite-2025-11-19-21-26-26.webp")),
  @("images/projects/run-the-night-series.png", @("https://cloud-1de12d.becdn.net/media/original/7e4f5af050c2eb1f508b86af738aad8c/screencapture-runthenightseries-home-2026-05-29-15-11-08.png", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/7e4f5af050c2eb1f508b86af738aad8c/screencapture-runthenightseries-home-2026-05-29-15-11-08.png")),
  @("images/projects/1st-cork-sea-scouts.webp", @("https://cloud-1de12d.becdn.net/media/original/f69c21bb3cb4320d84da125e1e45553d/screencapture-1stcork-2026-04-30-15-05-25.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/f69c21bb3cb4320d84da125e1e45553d/screencapture-1stcork-2026-04-30-15-05-25.webp")),
  @("images/websites/supportstjames.png", @("https://cloud-1de12d.becdn.net/media/original/9d923b7dc35db96da465d2914ab0107d/screencapture-supportstjames-ie-2026-05-29-16-29-20.png", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/9d923b7dc35db96da465d2914ab0107d/screencapture-supportstjames-ie-2026-05-29-16-29-20.png")),
  @("images/websites/sheehanconstructiongroup.webp", @("https://cloud-1de12d.becdn.net/media/original/ca2db1e778b97467533782a325e128df/construction.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/ca2db1e778b97467533782a325e128df/construction.webp")),
  @("images/websites/wiora.webp", @("https://cloud-1de12d.becdn.net/media/original/21089728230a847739d7ac827b3f0aef/wiora---tec-ecom.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/21089728230a847739d7ac827b3f0aef/wiora---tec-ecom.webp")),
  @("images/websites/infinityflowers.webp", @("https://cloud-1de12d.becdn.net/media/original/8dc99d63f6598585c26f13915a5b16ad/florist-ecom.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/8dc99d63f6598585c26f13915a5b16ad/florist-ecom.webp")),
  @("images/websites/totalcleaningsupplies.webp", @("https://cloud-1de12d.becdn.net/media/original/7017c5af9309fbd807207ad7febd1df2/cleaning-supplies.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/7017c5af9309fbd807207ad7febd1df2/cleaning-supplies.webp")),
  @("images/websites/forthandledger.webp", @("https://cloud-1de12d.becdn.net/media/original/4d57e9e77024bcd750ef39a2bb66f461/accounting.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/4d57e9e77024bcd750ef39a2bb66f461/accounting.webp")),
  @("images/websites/galwaytaxis.webp", @("https://cloud-1de12d.becdn.net/media/original/16fab3e15cb0bbab3078458daa4d1513/galway-taxis.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/16fab3e15cb0bbab3078458daa4d1513/galway-taxis.webp")),
  @("images/websites/moneyfoundations.webp", @("https://cloud-1de12d.becdn.net/media/original/838eebe2ddbfe02a7985ab561e3c84df/screencapture-moneyfoundations-ie-2026-10-22-11-50-53.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/838eebe2ddbfe02a7985ab561e3c84df/screencapture-moneyfoundations-ie-2026-10-22-11-50-53.webp")),
  @("images/websites/thefashionstudio.webp", @("https://cloud-1de12d.becdn.net/media/original/8ce275592ddff9accb7297ed6d8bb523/fashion-studio-ecom.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/8ce275592ddff9accb7297ed6d8bb523/fashion-studio-ecom.webp")),
  @("images/websites/eyresquarenewsagents.webp", @("https://cloud-1de12d.becdn.net/media/original/91cc6bc94bc80ec2cd3314e5777f728f/ecom-eyresquare.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/91cc6bc94bc80ec2cd3314e5777f728f/ecom-eyresquare.webp")),
  @("images/websites/linksofireland.webp", @("https://cloud-1de12d.becdn.net/media/original/49e27a2603c2b26075a38c02d4462c01/golf.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/49e27a2603c2b26075a38c02d4462c01/golf.webp")),
  @("images/websites/inchera.webp", @("https://cloud-1de12d.becdn.net/media/original/df691b1b894a53332978fa18bbbf05bb/inchera.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/df691b1b894a53332978fa18bbbf05bb/inchera.webp")),
  @("images/websites/playplus.webp", @("https://cloud-1de12d.becdn.net/media/original/41d93b63d492c561f7a5e654b6b8570b/playplus.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/41d93b63d492c561f7a5e654b6b8570b/playplus.webp")),
  @("images/websites/precisionmechanical.webp", @("https://cloud-1de12d.becdn.net/media/original/7ee0e89676397f630ec9a6be6323e291/mechanical.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/7ee0e89676397f630ec9a6be6323e291/mechanical.webp")),
  @("images/websites/stericlenz.webp", @("https://cloud-1de12d.becdn.net/media/original/b0d2bcb0c94bdcef0110c3445878915f/cleaning.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/b0d2bcb0c94bdcef0110c3445878915f/cleaning.webp")),
  @("images/websites/crossfitclaregalway.webp", @("https://cloud-1de12d.becdn.net/media/original/db2ff6c7b814cc0f0673c335cd3b5515/screencapture-crossfitclaregalway-ie-2025-12-06-18-29-51.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/db2ff6c7b814cc0f0673c335cd3b5515/screencapture-crossfitclaregalway-ie-2025-12-06-18-29-51.webp")),
  @("images/websites/cawleycatering.webp", @("https://cloud-1de12d.becdn.net/media/original/098659c93a5a0b8e3a6e17db96378db1/cawley-catering.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/098659c93a5a0b8e3a6e17db96378db1/cawley-catering.webp")),
  @("images/websites/skprodesign.webp", @("https://cloud-1de12d.becdn.net/media/original/192081224f72e3f40758964183e8737a/skpro-design.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/192081224f72e3f40758964183e8737a/skpro-design.webp")),
  @("images/websites/celestialblessingstherapy.webp", @("https://cloud-1de12d.becdn.net/media/original/3369b6cc285f066913b26cb6de4860a9/reflex---reiki.webp", "https://cloud-1de12d.becdn.net/media/iW=5000&iH=any/3369b6cc285f066913b26cb6de4860a9/reflex---reiki.webp"))
)
$ok=0;$skip=0;$fail=0
foreach ($f in $files) {
  $dest=$f[0]; $urls=$f[1]
  if ((Test-Path $dest) -and ((Get-Item $dest).Length -gt 0)) { $skip++; continue }
  New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
  $done=$false; $lastErr=""
  foreach ($u in $urls) {
    try {
      Invoke-WebRequest -Uri $u -OutFile $dest -UserAgent $ua -Headers $headers -UseBasicParsing -ErrorAction Stop
      if ((Test-Path $dest) -and ((Get-Item $dest).Length -gt 0)) { $done=$true; break }
    } catch { $lastErr = $_.Exception.Message; if (Test-Path $dest) { Remove-Item $dest -Force } }
  }
  if ($done) { Write-Host "downloaded $dest"; $ok++ } else { Write-Host "FAILED     $dest  --  $lastErr"; Write-Host "           $($urls[0])"; $fail++ }
}
Write-Host ""; Write-Host "Done: $ok downloaded, $skip already present, $fail FAILED."
if ($fail -gt 0) { Write-Host "Some downloads failed - copy the FAILED lines above and send them to Claude." }
