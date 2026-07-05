# ============================================================
# Download-YouTubeVideo.ps1
# Prompts for a YouTube URL and downloads it using yt-dlp
# ============================================================

# --- CONFIGURE THIS: where downloaded videos should be saved ---
$DownloadDirectory = "D:\Files\Videos\Downloads"

# --- Path to yt-dlp.exe. If yt-dlp is already in your PATH, "yt-dlp" alone works. ---
$YtDlpPath = "yt-dlp"


# Ask the user for the YouTube link
$VideoUrl = Read-Host "Enter the YouTube video URL"

# Basic validation
if ([string]::IsNullOrWhiteSpace($VideoUrl)) {
    Write-Host "No URL entered. Exiting." -ForegroundColor Red
    exit 1
}

if ($VideoUrl -notmatch "^(https?://)?(www\.)?(youtube\.com|youtu\.be)/") {
    Write-Host "Warning: This doesn't look like a YouTube URL. Continuing anyway..." -ForegroundColor Yellow
}

if ($VideoUrl -match "^([^&]*)&") {
    $OriginalUrl = $VideoUrl
    $VideoUrl = $Matches[1]
    Write-Host "Trimmed URL: $OriginalUrl" -ForegroundColor DarkGray
    Write-Host "Using: $VideoUrl" -ForegroundColor DarkGray
}

Write-Host "`nDownloading video..." -ForegroundColor Cyan
Write-Host "Save location: $DownloadDirectory`n" -ForegroundColor Cyan

# Output template: saves as "Video Title.ext" inside the download directory
$OutputTemplate = Join-Path $DownloadDirectory "%(title)s.%(ext)s"

# Run yt-dlp
# -f: format selection (best video+audio merged as mp4)
# -o: output file path/template
& $YtDlpPath $VideoUrl --js-runtimes deno

# Check if the command succeeded
if ($LASTEXITCODE -eq 0) {
    Write-Host "`nDownload completed successfully!" -ForegroundColor Green
} else {
    Write-Host "`nSomething went wrong. yt-dlp exited with code $LASTEXITCODE." -ForegroundColor Red
}

Read-Host "`nPress Enter to exit"