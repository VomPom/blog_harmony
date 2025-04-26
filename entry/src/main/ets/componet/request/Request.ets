import { http } from "@kit.NetworkKit";
import { uri } from "@kit.ArkTS";
import hilog from '@ohos.hilog';
import Response from "./Response";
import { log } from "../Log";

const TAG = "Request";
const BASE_URL: string = "https://julis.wang/";


export default class Request {
  private static instance: Request;

  private constructor() {
  }

  static getInstance(): Request {
    if (Request.instance === undefined) {
      Request.instance = new Request();
    }
    return Request.instance;
  }


  static async get<T>(path: string): Promise<Response<T>> {
    return Request.getInstance().request<T>(path, http.RequestMethod.GET, undefined)
  }

  // todo:: post method ...
  static async post<T>(path: string): Promise<Response<T>> {
    return Request.getInstance().request<T>(path, http.RequestMethod.POST, undefined)
  }

  async request<T>(path: string, method: http.RequestMethod, extraData?: object): Promise<Response<T>> {
    return new Promise<Response<T>>((resolve, reject) => {
      const url = BASE_URL + path;
      log('request url:' + url)
      const httpRequest = http.createHttp();

      if (method === http.RequestMethod.POST) {
        // headers.contentType = "application/x-www-form-urlencoded"
        if (!extraData) {
          // POST 必须有请求体，否则会报 Parameter error
          extraData = new Object();
        }
      }
      httpRequest.request(url, {
        method: method,
        expectDataType: http.HttpDataType.OBJECT,
        // header: headers,
        extraData: extraData
      }, (err, data) => {
        hilog.debug(0, TAG, "http request response:" + JSON.stringify(data) + " err:" + err)
        const res = new Response<T>()
        if (data.responseCode == 200) {
          const r = data.result as Response<T>
          res.api = r.api
          res.data = r.data
        } else {
          const res = new Response<T>()
          res.errorCode = data.responseCode
        }
        resolve(res)
      })
    })
  }

  parseUri(url: string): uri.URI {
    return new uri.URI(url);
  }
}