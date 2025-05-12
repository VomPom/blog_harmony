import { BaseRepository } from "./BaseRepository";

/**
 * Created by @juliswang on 2025/04/30 14:30
 *
 * @Description
 */
const KEY_DARK = "key_dark"

export class ConfigRepository extends BaseRepository {
  private static instance: ConfigRepository;

  static getInstance(): ConfigRepository {
    if (ConfigRepository.instance === undefined) {
      ConfigRepository.instance = new ConfigRepository();
    }
    return ConfigRepository.instance;
  }

  saveIsDark(isDark: boolean) {
    this.saveData(KEY_DARK, isDark)
  }

  isDark(): boolean {
    return this.loadData(KEY_DARK) as boolean
  }

  preferencesName(): string {
    return "configs"
  }
}