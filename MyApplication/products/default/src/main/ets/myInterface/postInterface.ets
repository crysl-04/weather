//关于post的接口
import { relationalStore, ValuesBucket } from '@kit.ArkData'

export interface myPost extends ValuesBucket{
  id:0,
  title:string;
  // author:string;
  city:string;
  contents:string;

}