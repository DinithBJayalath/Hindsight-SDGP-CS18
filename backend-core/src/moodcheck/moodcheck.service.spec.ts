import { Test, TestingModule } from '@nestjs/testing';
import { MoodcheckService } from './moodcheck.service';

describe('MoodcheckService', () => {
  let service: MoodcheckService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [MoodcheckService],
    }).compile();

    service = module.get<MoodcheckService>(MoodcheckService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
