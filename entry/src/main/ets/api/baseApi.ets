import Request from "../componet/request/Request";

export function request<T>(path: string): Promise<T> {
  return new Promise((resolve, reject) => {
    Request.get<T>(path)
      .then((result) => {
        resolve(result.data as T)
      })
      .catch(() => {
        reject('error.')
      });
  })
}