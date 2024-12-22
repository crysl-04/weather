/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import { relationalStore } from '@kit.ArkData';
import InstrumentsData from '../../../viewmodel/InstrumentsData';
import CommonConstants from '../../constants/CommonConstants';
import Rdb from '../Rdb';

export default class InstrumentsTable {
  private instrumentsTable = new Rdb(CommonConstants.INSTRUMENTS_TABLE.tableName, CommonConstants.INSTRUMENTS_TABLE.sqlCreate,
    CommonConstants.INSTRUMENTS_TABLE.columns);

  constructor(callback: Function = () => {}) {
    this.instrumentsTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {}) {
    this.instrumentsTable.getRdbStore(callback);
  }

  insertData(name: string, type: string, brand: string, imageUrl: string, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = {
      name: name,
      type: type,
      brand: brand,
      imageUrl: imageUrl
    };
    this.instrumentsTable.insertData(valueBucket, callback);
  }

  deleteData(instrumentId: number, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.INSTRUMENTS_TABLE.tableName);
    predicates.equalTo('id', instrumentId);
    this.instrumentsTable.deleteData(predicates, callback);
  }

  updateData(instrumentId: number, name: string, type: string, brand: string, imageUrl: string, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = {
      name: name,
      type: type,
      brand: brand,
      imageUrl: imageUrl
    };
    let predicates = new relationalStore.RdbPredicates(CommonConstants.INSTRUMENTS_TABLE.tableName);
    predicates.equalTo('id', instrumentId);
    this.instrumentsTable.updateData(predicates, valueBucket, callback);
  }

  queryInstruments(type: string | null, name: string | null, callback: Function, isAll: boolean = true) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.INSTRUMENTS_TABLE.tableName);

    // 根据 isAll 参数判断是否添加条件
    if (!isAll) {
      if (type) {
        predicates.equalTo('type', type);
      }
      if (name) {
        predicates.equalTo('name', name);
      }
    }

    this.instrumentsTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        console.log(`${CommonConstants.INSTRUMENTS_TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: InstrumentsData[] = [];
        for (let i = 0; i < count; i++) {
          const tmp: InstrumentsData = new InstrumentsData(
            resultSet.getDouble(resultSet.getColumnIndex('id')),
            resultSet.getString(resultSet.getColumnIndex('name')),
            resultSet.getString(resultSet.getColumnIndex('type')),
            resultSet.getString(resultSet.getColumnIndex('brand')),
            resultSet.getString(resultSet.getColumnIndex('imageUrl'))
          );
          result[i] = tmp;
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }

}
