import grpc
from concurrent import futures
import algorithms_pb2 as algorithms_pb2
import algorithms_pb2_grpc as algorithms_pb2_grpc

class JournalAnalyzer(algorithms_pb2_grpc.JournalAnalyzerServicer):
    def analyze(self, request, context):
        print("Received request")
        return algorithms_pb2.AnalyzeResponse(result="JournalAnalyzer: Analyzing journal")

def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    algorithms_pb2_grpc.add_JournalAnalyzerServicer_to_server(JournalAnalyzer(), server)
    server.add_insecure_port("[::]:50051")
    server.start()
    server.wait_for_termination()

if __name__ == "__main__":
    serve()