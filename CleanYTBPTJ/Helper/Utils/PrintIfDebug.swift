//
//  PrintIfDebug.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/13.
//

func printIfDebug(_ string: String) {
#if DEBUG
    print(string)
#endif
}
