import json
from dotenv import load_dotenv
import os
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import FAISS
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.schema import Document
from langchain_core.output_parsers import StrOutputParser, JsonOutputParser

# Loading the environment variables
load_dotenv(override=True)
# Setting the OpenAI API key
openai_api_key = os.getenv("OPENAI_API_KEY")
# Loading the dataset and creating the vector store
with open('Emotions_dataset_cardiff_oai.json') as file:
    data = json.load(file)
# Creating a list of documents from the dataset
documents = [Document(page_content=entry['journal_entry']) for entry in data]
# Setting  up the embeddings model
emb_model = OpenAIEmbeddings(model="text-embedding-3-small", openai_api_key=openai_api_key)
# Creating the vector store and saving it locally
vector_store = FAISS.from_documents(documents=documents, embedding=emb_model)
vector_store.save_local('emotions_vector_store')
# List of emotions to choose from
EMOTIONAL_STATES = ["enthusiasm",
                     "love",
                     "fun",
                     "happiness",
                     "relief",
                     "surprise",
                     "neutral",
                     "boredom",
                     "sadness",
                     "anger",
                     "worry",
                     "hate"]
# Template for the prompt
TEMPLATE = """Analyze the emotional content of the following journal entry by comparing it with similar past entries:

Context entries: {retrieved_journal_entries}
New journal entry: {user_journal_entry}
Available emotion categories: {emotion_categories}

Instructions:
1. Compare the new entry with the retrieved similar entries
2. Identify the most relevant emotion from the provided categories only
3. Calculate a sentiment score (-1.0 to 1.0) based on the emotional tone

Return your analysis in valid JSON format with the following structure:
{{
  "emotion": "selected_emotion",
  "sentiment_score": numerical_score
}}

Note: Ensure you only select an emotion from the provided emotion_categories list. The sentiment_score should be a number between -1.0 and 1.0, not a string."""

def Generate(query):
    '''This function takes the user's query and context and generates the most relevant emotion.  
    Args:
    query: str: The user's journal entry.  
    returns:
    str: The most relevant emotion to the user's journal entry and the sentiment score of the journal entry.
    separated by a comma.
    '''
    # Setting up the prompt for the chain
    prompt = ChatPromptTemplate.from_template(TEMPLATE)
    # Loading the vector store and setting up the retriever
    loaded_vectors = FAISS.load_local('emotions_vector_store', embeddings=emb_model, allow_dangerous_deserialization=True)
    retriever = loaded_vectors.as_retriever(k=7)
    # Setting up the the LLM
    llm = ChatOpenAI(model_name = "gpt-4o-mini", temperature = 0)
    rag_chain = (  
    retriever 
    # The lambda function is used to pass the context and the query to the next step in the chain
    | (lambda docs: {'retrieved_journal_entries': docs, 'user_journal_entry': query, 'emotion_categories': EMOTIONAL_STATES})  
    | prompt
    | llm
    # The output parser is used to parse the output and format it as a string
    | JsonOutputParser()
    )
    response = rag_chain.invoke(query)
    return response