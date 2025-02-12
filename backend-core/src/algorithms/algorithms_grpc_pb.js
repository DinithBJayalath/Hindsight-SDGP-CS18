// GENERATED CODE -- DO NOT EDIT!

'use strict';
var grpc = require('@grpc/grpc-js');
var algorithms_algorithms_pb = require('../algorithms/algorithms_pb.js');

function serialize_algorithms_AnalyzeRequest(arg) {
  if (!(arg instanceof algorithms_algorithms_pb.AnalyzeRequest)) {
    throw new Error('Expected argument of type algorithms.AnalyzeRequest');
  }
  return Buffer.from(arg.serializeBinary());
}

function deserialize_algorithms_AnalyzeRequest(buffer_arg) {
  return algorithms_algorithms_pb.AnalyzeRequest.deserializeBinary(new Uint8Array(buffer_arg));
}

function serialize_algorithms_AnalyzeResponse(arg) {
  if (!(arg instanceof algorithms_algorithms_pb.AnalyzeResponse)) {
    throw new Error('Expected argument of type algorithms.AnalyzeResponse');
  }
  return Buffer.from(arg.serializeBinary());
}

function deserialize_algorithms_AnalyzeResponse(buffer_arg) {
  return algorithms_algorithms_pb.AnalyzeResponse.deserializeBinary(new Uint8Array(buffer_arg));
}


var JournalAnalyzerService = exports.JournalAnalyzerService = {
  analyze: {
    path: '/algorithms.JournalAnalyzer/analyze',
    requestStream: false,
    responseStream: false,
    requestType: algorithms_algorithms_pb.AnalyzeRequest,
    responseType: algorithms_algorithms_pb.AnalyzeResponse,
    requestSerialize: serialize_algorithms_AnalyzeRequest,
    requestDeserialize: deserialize_algorithms_AnalyzeRequest,
    responseSerialize: serialize_algorithms_AnalyzeResponse,
    responseDeserialize: deserialize_algorithms_AnalyzeResponse,
  },
};

exports.JournalAnalyzerClient = grpc.makeGenericClientConstructor(JournalAnalyzerService, 'JournalAnalyzer');
