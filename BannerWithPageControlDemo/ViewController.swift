//
//  ViewController.swift
//  BannerWithPageControlDemo
//
//  Created by Ethan Hung on 2024/5/9.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bannerScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    let images = ["cat", "chicken", "dog"]
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showFirstBannerView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }

    @IBAction func changePageControl(_ sender: UIPageControl) {
        // 計算目標頁面的 x 軸偏移量
        // sender.currentPage 是當前 UIPageControl 上選中的頁碼
        let xPosition = CGFloat(sender.currentPage) * bannerScrollView.bounds.width

        // 創建一個 CGPoint，用來表示 UIScrollView 應該滾動到的新位置
        let point = CGPoint(x: xPosition, y: 0.0)

        // 設定 UIScrollView 滾動到計算出的新位置，並設定動畫效果為「true」以獲得平滑滾動效果
        bannerScrollView.setContentOffset(point, animated: true)
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func showFirstBannerView() {
        let width = bannerScrollView.bounds.width
        bannerScrollView.contentOffset = CGPoint(x: width, y: 0)
        pageControl.currentPage = 0
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let width = bannerScrollView.bounds.width
        let currentPage = Int(bannerScrollView.contentOffset.x / width)
        let totalPages = images.count

        // 圖片        [ (3) (1) (2) (3) (1) ]
        // totalPages [      0   1   2      ] (array)
        // totalPages [      1   2   3      ] (.count)
        // currentPage[  0   1   2   3   4  ] (array)
        // currentPage[  1   2   3   4   5  ] (.count)
        
        if currentPage == 0 {
            // 最前面的額外圖片（3），跳轉到實際的最後一張圖片（3）
            bannerScrollView.contentOffset = CGPoint(x: width * CGFloat(totalPages), y: 0)
            pageControl.currentPage = totalPages - 1
        } else if currentPage == totalPages + 1 {
            // 最後面的額外圖片（1），跳轉到實際的第一張圖片（1）
            bannerScrollView.contentOffset = CGPoint(x: width, y: 0)
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage = currentPage - 1
        }
    }
    func startTimer() {
        // 創建一個重複執行的計時器，每隔 3 秒觸發一次
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let width = self.bannerScrollView.frame.width
            let currentOffset = self.bannerScrollView.contentOffset.x
            let nextOffset = currentOffset + width
            let totalPages = self.images.count

            // 如果 nextOffset 超過了最後一頁的偏移量，調整到第一頁
            if nextOffset >= width * CGFloat(self.images.count + 1) {
                let newOffset = CGPoint(x: width, y: 0)
                self.bannerScrollView.setContentOffset(newOffset, animated: true)
                self.pageControl.currentPage = 0  // 更新pageControl到第一頁
            } else {
                // 否則正常滾動
                let newOffset = CGPoint(x: nextOffset, y: 0)
                self.bannerScrollView.setContentOffset(newOffset, animated: true)
                let newPage = Int(nextOffset / width) - 1
                if newPage < totalPages {
                    self.pageControl.currentPage = newPage  // 更新pageControl
                }
            }
        }
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
