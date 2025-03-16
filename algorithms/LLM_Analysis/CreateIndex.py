import os
import json
from dotenv import load_dotenv
from langchain.schema import Document
from langchain.vectorstores import FAISS
from langchain.embeddings import OpenAIEmbeddings

# Loading the environment variables
load_dotenv(override=True)
# Setting the OpenAI API key
openai_api_key = os.getenv("OPENAI_API_KEY")
# Loading the dataset and creating the vector store
with open('./algorithms/LLM_Analysis/tests/Emotions_dataset_cardiff_oai.json') as file:
    data = json.load(file)
# Creating a list of documents from the dataset
documents = [Document(page_content=entry['journal_entry']) for entry in data]
# Setting  up the embeddings model
emb_model = OpenAIEmbeddings(model="text-embedding-3-small", openai_api_key=openai_api_key)
# Creating the vector store and saving it locally
vector_store = FAISS.from_documents(documents=documents, embedding=emb_model)
vector_store.save_local('./algorithms/LLM_Analysis/tests/emotions_vector_store')