from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
import os
from pptx import Presentation
from transformers import pipeline
import pdfplumber

app = FastAPI()

# ------------------ CORS CONFIG ------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],  
    allow_headers=["*"],
)
# ------------------------------------------------


# ------------------ AI MODELS ------------------
summarizer = pipeline(
    "summarization",
    model="facebook/bart-large-cnn"
)

def generate_summary(text):
    return summarizer(
        text[:1024],
        max_length=150,
        min_length=60,
        do_sample=False
    )[0]["summary_text"]

def generate_bullets(summary):
    return summary.split(". ")

quiz_generator = pipeline(
    "text2text-generation",
    model="google/flan-t5-base"
)

def generate_quiz(text):
    prompt = f"""
    Create 5 MCQ questions from the following text:
    {text}
    """
    return quiz_generator(prompt, max_length=512)[0]["generated_text"]
# ------------------------------------------------


# ------------------ FILE HANDLING ------------------
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

def extract_pdf_text(path):
    text = ""
    with pdfplumber.open(path) as pdf:
        for page in pdf.pages:
            if page.extract_text():
                text += page.extract_text() + "\n"
    return text

def extract_ppt_text(path):
    prs = Presentation(path)
    text = ""
    for slide in prs.slides:
        for shape in slide.shapes:
            if hasattr(shape, "text"):
                text += shape.text + "\n"
    return text
# --------------------------------------------------


# ------------------ API ENDPOINTS ------------------
@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    path = f"{UPLOAD_DIR}/{file.filename}"
    with open(path, "wb") as f:
        f.write(await file.read())

    return {
        "filename": file.filename,
        "path": path
    }

@app.post("/process")
async def process_file(file: UploadFile = File(...)):
    path = f"{UPLOAD_DIR}/{file.filename}"
    with open(path, "wb") as f:
        f.write(await file.read())

    if file.filename.endswith(".pdf"):
        text = extract_pdf_text(path)
    else:
        text = extract_ppt_text(path)

    summary = generate_summary(text)
    bullets = generate_bullets(summary)
    quiz = generate_quiz(text)

    return {
        "summary": summary,
        "bullets": bullets,
        "quiz": quiz
    }
# --------------------------------------------------
