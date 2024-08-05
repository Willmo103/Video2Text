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
