export class CreateBreathingSessionDto {
  readonly userId: string;
  readonly duration: number;
  readonly audioRecording?: string;
}
