import grpc
from concurrent import futures
import algorithms_pb2 as algorithms_pb2
import algorithms_pb2_grpc as algorithms_pb2_grpc
from LLM_Analysis.JournalAnalysis import Generate

class JournalAnalyzer(algorithms_pb2_grpc.JournalAnalyzerServicer):
    def analyze(self, request, context):
        result = Generate(request.query)
        print(result)
        emotion = result.split('\n')[0].split(': ')[1].strip()
        sentiment_score = result.split('\n')[1].split(': ')[1].strip()
        print(f"Emotional analysis of journal entry is: {emotion}, Sentiment score is: {sentiment_score}")
        return algorithms_pb2.AnalyzeResponse(response = emotion)

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    algorithms_pb2_grpc.add_JournalAnalyzerServicer_to_server(JournalAnalyzer(), server)
    server.add_insecure_port("[::]:50051")
    server.start()
    print("Server started at port 50051")
    server.wait_for_termination()

if __name__ == "__main__":
    serve()