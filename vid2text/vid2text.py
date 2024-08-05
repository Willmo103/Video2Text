import ffmpeg
import whisper
import sqlite3
import os
from datetime import datetime
import argparse

DB_SCHEMA = """
CREATE TABLE IF NOT EXISTS transcriptions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    video_path TEXT,
    audio_path TEXT,
    transcript_path TEXT,
    timestamp TEXT
);
"""

def init_db(db_path):
    with sqlite3.connect(db_path) as conn:
        cursor = conn.cursor()
        cursor.execute(DB_SCHEMA)
        conn.commit()

def extract_audio(video_path, audio_output_path):
    ffmpeg.input(video_path).output(audio_output_path).run()

def transcribe_audio(audio_path):
    model = whisper.load_model("base")
    result = model.transcribe(audio_path)
    return result['text']

def store_transcription_info(db_path, video_path, audio_path, transcript_path):
    with sqlite3.connect(db_path) as conn:
        cursor = conn.cursor()
        cursor.execute("""
        INSERT INTO transcriptions (video_path, audio_path, transcript_path, timestamp)
        VALUES (?, ?, ?, ?)
        """, (video_path, audio_path, transcript_path, datetime.now().isoformat()))
        conn.commit()

def main():
    parser = argparse.ArgumentParser(description='Video to Text Transcription Tool')
    parser.add_argument('-v', '--video', required=True, help='Path to the input video file')
    parser.add_argument('-o', '--output', required=True, help='Directory to save the output audio and transcript')
    parser.add_argument('-d', '--db', required=True, help='Path to the SQLite database file')

    args = parser.parse_args()

    video_path = args.video
    output_dir = args.output
    db_path = args.db

    os.makedirs(output_dir, exist_ok=True)
    init_db(db_path)

    audio_path = os.path.join(output_dir, os.path.splitext(os.path.basename(video_path))[0] + '.wav')
    transcript_path = os.path.join(output_dir, os.path.splitext(os.path.basename(video_path))[0] + '.txt')

    # Extract audio and transcribe
    extract_audio(video_path, audio_path)
    transcript = transcribe_audio(audio_path)

    # Save transcript to file
    with open(transcript_path, 'w') as f:
        f.write(transcript)

    # Store transcription information in the database
    store_transcription_info(db_path, video_path, audio_path, transcript_path)

if __name__ == '__main__':
    main()
