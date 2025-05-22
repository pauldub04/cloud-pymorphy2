from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List, Dict, Any, Optional
from app.morphology import MorphologyAnalyzer

router = APIRouter()
analyzer = MorphologyAnalyzer()


class TextRequest(BaseModel):
    text: str


class WordRequest(BaseModel):
    word: str
    form: Optional[Dict[str, str]] = None


class AnalysisResult(BaseModel):
    result: List[Dict[str, Any]]


@router.post("/analyze", response_model=AnalysisResult, tags=["Morphology"])
async def analyze_text(request: TextRequest):
    """
    Analyzes a text and returns morphological information for each word.
    """
    if not request.text.strip():
        raise HTTPException(status_code=400, detail="Text cannot be empty")

    analysis = analyzer.analyze_text(request.text)
    return {"result": analysis}


@router.post("/normalize", response_model=Dict[str, str], tags=["Morphology"])
async def normalize_text(request: TextRequest):
    """
    Normalizes all words in the text to their base (normal) forms.
    """
    if not request.text.strip():
        raise HTTPException(status_code=400, detail="Text cannot be empty")

    normalized = analyzer.normalize_text(request.text)
    return {"result": normalized}
