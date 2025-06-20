#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
数据准备脚本 - 将空教室CSV数据复制到HarmonyOS应用的rawfile目录
"""

import os
import shutil
import json
from pathlib import Path

def main():
    # 源数据目录
    source_dir = Path("../kjscx/2025春季")
    # 目标目录
    target_dir = Path("entry/src/main/resources/rawfile/csv")
    
    print("开始准备空教室查询数据...")
    
    # 创建目标目录
    target_dir.mkdir(parents=True, exist_ok=True)
    
    # 校区映射
    campus_mapping = {
        "一校区": "campus1",
        "二校区": "campus2"
    }
    
    copied_files = 0
    
    # 遍历校区
    for campus_dir in source_dir.iterdir():
        if not campus_dir.is_dir():
            continue
            
        campus_name = campus_dir.name
        if campus_name not in campus_mapping:
            continue
            
        target_campus_dir = target_dir / campus_mapping[campus_name]
        target_campus_dir.mkdir(exist_ok=True)
        
        print(f"处理 {campus_name}...")
        
        # 遍历教学楼
        for building_dir in campus_dir.iterdir():
            if not building_dir.is_dir():
                continue
                
            building_name = building_dir.name
            target_building_dir = target_campus_dir / building_name
            target_building_dir.mkdir(exist_ok=True)
            
            # 复制CSV文件
            for csv_file in building_dir.glob("*.csv"):
                if "空闲教室" in csv_file.name:
                    target_file = target_building_dir / csv_file.name
                    shutil.copy2(csv_file, target_file)
                    copied_files += 1
                    print(f"  复制: {csv_file.name}")
    
    # 创建校区-教学楼映射文件
    create_building_mapping(source_dir, target_dir)
    
    print(f"\n数据准备完成！")
    print(f"总共复制了 {copied_files} 个CSV文件")
    print(f"数据存储在: {target_dir}")

def create_building_mapping(source_dir, target_dir):
    """创建校区-教学楼映射文件"""
    mapping = {}
    
    for campus_dir in source_dir.iterdir():
        if not campus_dir.is_dir():
            continue
            
        campus_name = campus_dir.name
        buildings = []
        
        for building_dir in campus_dir.iterdir():
            if building_dir.is_dir():
                buildings.append(building_dir.name)
        
        mapping[campus_name] = buildings
    
    # 保存映射文件
    mapping_file = target_dir / "building_mapping.json"
    with open(mapping_file, 'w', encoding='utf-8') as f:
        json.dump(mapping, f, ensure_ascii=False, indent=2)
    
    print(f"创建映射文件: {mapping_file}")

if __name__ == "__main__":
    main() 