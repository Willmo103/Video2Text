# CLI Tool: vid2text

## Features

**The CLI tool will have the following features:**

    - Extract Audio: Extract audio from the provided video file.
    - Transcribe Audio: Generate a transcript from the extracted audio.
    - Database Tracking: Store paths and metadata for each transcription process.
    - SQLite Database Schema

**The database will have a table transcriptions with the following fields:**

    - id: Unique identifier for each record.
    - video_path: Path to the input video file.
    - audio_path: Path to the extracted audio file.
    - transcript_path: Path to the generated transcript.
    - timestamp: Date and time when the transcription was created.

## CLI Argument Schema

    --video (-v): Path to the input video file.
    --output (-o): Directory where the audio and transcript will be saved.
    --db (-d): Path to the SQLite database file.

## Key Changes Version 0.0.3

**print_usage Function:**

This function provides a clear usage message with examples. It details the required `-v` or `--video` argument and the optional `-u` or `--update` argument.

**Argument Check:**

In the `main()` function, the script now checks if neither `args.video` nor `args.update` is provided. If neither argument is present, it prints the usage message and exits.

**Interactive Configuration Update:**

The `-u` or `--update` option is retained for updating the configuration interactively.

## Usage Instructions

To Transcribe a Video:

    ```cmd
    vid2text -v C:\path\to\video.mp4
    ```

To Update Configuration Settings:

    ```cmd
    vid2text -u
    ```

Without Arguments:

- If you run `vid2text` without any arguments, it will display the usage message and guide you on how to use the tool.
