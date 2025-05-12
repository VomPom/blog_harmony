import preferences from '@ohos.data.preferences';
import { log } from '../Log';
import { ValueType } from '@kit.ArkData';
import { GlobalContext } from '../GlobalContext';

/**
 * Created by @juliswang on 2025/04/29 11:01
 *
 * @Description
 */
export type P<T> = Promise<T>

export abstract class BaseRepository {
  /**
   * 获取数据，从缓存或者网络请求获取
   *
   * @template T      响应数据的类型结构
   * @template P      请求参数的类型结构
   *
   * @param cacheKey      对应缓存的key
   * @param forceUpdate   true 使用网络请求，false 读取本地数据，失败再请求网络数据
   * @param netFunc       使用网络请求的时候的方法
   * @param params        使用网络请求的时候的请求参数
   * @returns
   */
  requestData<T, P>(
    cacheKey: string,
    forceUpdate: boolean = false,
    netFunc: (params: P) => Promise<T>,
    params: P
  ): Promise<T> {
    return new Promise((resolve, reject) => {
      let p = this.getPreferences()
      let cache = p.getSync(cacheKey, "")
      if (cache == "" || forceUpdate) {
        if (forceUpdate) {
          log('load data by force fresh.')
        }
        if (cache == "") {
          log('load data by empty data.')
        }
        netFunc(params)
          .then(async (data) => {
            if (data == undefined) {
              reject('response data is undefined.')
            } else {
              p.putSync(cacheKey, JSON.stringify(data))
              p.flushSync()
              resolve(data as T)
            }

          })
          .catch(reject)
      } else {
        log(`load data[${cacheKey}] from local cache.`)
        resolve(JSON.parse(cache as string) as T)
      }
    })
  }

  /**
   * 无参方法请求
   *
   * @param cacheKey
   * @param forceUpdate
   * @param netFunc
   * @returns
   */
  requestDataWithoutParms<T>(
    cacheKey: string,
    forceUpdate: boolean = false,
    netFunc: () => Promise<T>,
  ): Promise<T> {
    return this.requestData(cacheKey, forceUpdate, netFunc, undefined)
  }

  /**
   * 将数据直接保存再本地
   * @param key
   * @param value
   */
  saveData(key: string, value: ValueType) {
    let p = this.getPreferences()
    p.putSync(key, value)
    p.flushSync()
  }

  /**
   * 从本地读取数据
   * @param key
   * @returns
   */
  loadData(key: string): ValueType {
    let p = this.getPreferences()
    return p.getSync(key, "") as ValueType
  }

  /**
   * 获取本地缓存对象
   * todo:: use better efficient save api..
   * @returns
   */
  getPreferences() {
    let context = GlobalContext.getContext()
    return preferences.getPreferencesSync(context, { name: this.preferencesName() })
  }

  /**
   * 存储名
   * @returns
   */
  abstract preferencesName(): string
}
