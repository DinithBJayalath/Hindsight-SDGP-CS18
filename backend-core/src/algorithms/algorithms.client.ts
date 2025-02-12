import * as grpc from '@grpc/grpc-js';
import * as protoLoader from '@grpc/proto-loader';

const PROTO_PATH = "../proto/algorithms/algorithms.proto";
const packageDefinition = protoLoader.loadSync(PROTO_PATH);
const algorithmsProto:any  = grpc.loadPackageDefinition(packageDefinition).algorithms;

const client = new algorithmsProto.JournalAnalyzer(
    'localhost:50051', 
    grpc.credentials.createInsecure()
);

export function analyze(query: string) : Promise<string> {
    return new Promise((resolve, reject) => {
        client.analyze({query: query}, (err:any, response:any) => {
            if (err) {
                reject(err);
            } else {
                resolve(response.response);
            }
        });
    });
}
