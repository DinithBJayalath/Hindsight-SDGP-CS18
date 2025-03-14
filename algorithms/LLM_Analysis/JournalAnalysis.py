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
TEMPLATE = """Give the most relevant emotion to the following journal entry based on the sentiment score,
and the mapped emotions from the given context.
context: {context}
journal entry: {journal_entry}
Note: only choose from the following emotions and only output that emotion: {EMOTIONAL_STATES}, 
and give the sentiment score of the journal entry."""

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
    | (lambda docs: {'context': docs, 'journal_entry': query, 'EMOTIONAL_STATES': EMOTIONAL_STATES})  
    | prompt
    | llm
    # The output parser is used to parse the output and format it as a string
    | StrOutputParser()
    )
    response = rag_chain.invoke(query)
    return response