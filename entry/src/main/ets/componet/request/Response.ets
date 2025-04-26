export default class Response<T> {
  errorCode: number = 0
  errorMsg: string = ""
  data?: T = undefined
  api: string = ""

  isSuccess(): boolean {
    return this.errorCode === 0
  }

  isSuccessWithData(): boolean {
    return this.errorCode === 0 && this.data !== undefined;
  }

  getDataOrThrow(): T {
    return this.data!!
  }
}
