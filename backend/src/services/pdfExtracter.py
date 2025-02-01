from flask import Flask, request, jsonify
import requests
import io
from PyPDF2 import PdfReader

app = Flask(__name__)

@app.route('/extract-text', methods=['POST'])
def extract_text():
    try:
        # Get PDF URL from request
        data = request.json
        pdf_url = data.get("pdfUrl")

        if not pdf_url:
            return jsonify({"error": "PDF URL is required"}), 400

        # Download the PDF file
        response = requests.get(pdf_url)
        response.raise_for_status()  # Ensure request was successful

        # Read the PDF from bytes
        pdf_reader = PdfReader(io.BytesIO(response.content))
        
        extracted_text = ""
        for page in pdf_reader.pages:
            extracted_text += page.extract_text() + "\n"

        return jsonify({"text": extracted_text})
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5001)
