# vid2text/core.py
import ffmpeg
import whisper
import os
import sqlite3
from datetime import datetime


def extract_audio(video_path, audio_output_path):
    ffmpeg.input(video_path).output(audio_output_path).run()


def transcribe_audio(audio_path, model=None):
    if model is None:
        # Load the model once and keep it in memory
        model = whisper.load_model("base")
    result = model.transcribe(audio_path)
    return result['text']


def store_transcription_info(db_path, video_path, audio_path, transcript_path):
    with sqlite3.connect(db_path) as conn:
        cursor = conn.cursor()
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS transcriptions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            video_path TEXT,
            audio_path TEXT,
            transcript_path TEXT,
            timestamp TEXT
        );
        """)
        conn.commit()
        cursor.execute("""
        INSERT INTO transcriptions (video_path, audio_path, transcript_path, timestamp)
        VALUES (?, ?, ?, ?)
        """, (video_path, audio_path, transcript_path, datetime.now().isoformat()))
        conn.commit()
