import pymorphy2
from typing import List, Dict, Any, Optional


class MorphologyAnalyzer:
    def __init__(self):
        self.morph = pymorphy2.MorphAnalyzer()

    def analyze_text(self, text: str) -> List[Dict[str, Any]]:
        """
        Analyzes each word in the input text.
        """
        words = text.split()
        result = []

        for word in words:
            clean_word = word.strip(".,!?:;()[]{}\"'")
            if not clean_word:
                continue

            parsed = self.morph.parse(clean_word)[0]
            result.append(
                {
                    'word': clean_word,
                    'normal_form': parsed.normal_form,
                    'pos': parsed.tag.POS,
                    'gender': parsed.tag.gender,
                    'number': parsed.tag.number,
                    'case': parsed.tag.case,
                    'all_tags': str(parsed.tag),
                }
            )

        return result

    def normalize_text(self, text: str) -> str:
        """
        Converts all words in the text to their normal form.
        """
        words = text.split()
        normalized_words = []

        for word in words:
            # Preserve punctuation
            prefix = ''
            suffix = ''

            while word and not word[0].isalnum():
                prefix += word[0]
                word = word[1:]

            while word and not word[-1].isalnum():
                suffix = word[-1] + suffix
                word = word[:-1]

            if word:
                parsed = self.morph.parse(word)[0]
                normalized_words.append(prefix + parsed.normal_form + suffix)
            else:
                normalized_words.append(prefix + suffix)

        return ' '.join(normalized_words)
