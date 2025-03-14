import { Test, TestingModule } from '@nestjs/testing';
import { MoodCheckService } from './mood-check.service';

describe('MoodCheckService', () => {
  let service: MoodCheckService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MoodCheckService],
    }).compile();

    service = module.get<MoodCheckService>(MoodCheckService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
