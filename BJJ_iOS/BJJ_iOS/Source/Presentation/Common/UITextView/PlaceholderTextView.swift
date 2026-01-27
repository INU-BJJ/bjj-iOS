//
//  PlaceholderTextView.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/27/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class PlaceholderTextView: BaseView {

    // MARK: - Properties

    private let placeholder: String
    private let maxLength: Int?
    private let hasIndicator: Bool
    private let font: Fonts
    private let fontSize: CGFloat
    private let textViewCornerRadius: CGFloat

    // MARK: - DisposeBag

    private let disposeBag = DisposeBag()

    // MARK: - PublishRelay

    fileprivate let textRelay = BehaviorRelay<String>(value: "")

    // MARK: - UI Components

    private lazy var textView = UITextView().then {
        $0.setTextViewUI("", font: font, size: fontSize, color: .black)
    }

    private lazy var placeholderLabel = UILabel().then {
        $0.setLabel(placeholder, font: font, size: fontSize, color: .B_9_B_9_B_9)
    }

    private lazy var characterCountLabel = UILabel().then {
        $0.setLabel("0 / \(maxLength ?? 0)", font: font, size: fontSize, color: .B_9_B_9_B_9)
        $0.isHidden = !hasIndicator
    }

    // MARK: - Init

    init(
        placeholder: String,
        font: Fonts = .pretendard_medium,
        fontSize: CGFloat = 14,
        cornerRadius: CGFloat = 8,
        maxLength: Int? = nil,
        hasIndicator: Bool = false
    ) {
        self.placeholder = placeholder
        self.maxLength = maxLength
        self.hasIndicator = hasIndicator
        self.font = font
        self.fontSize = fontSize
        self.textViewCornerRadius = cornerRadius
        super.init(frame: .zero)
    }
    
    // MARK: - Set UI
    
    override func setUI() {
        setCornerRadius(radius: textViewCornerRadius)
        setBorder(color: .B_9_B_9_B_9)
    }
    
    // MARK: - Set Hierarchy

    override func setHierarchy() {
        [
            textView,
            placeholderLabel
        ].forEach(addSubview)
        
        if hasIndicator {
            addSubview(characterCountLabel)
        }
    }
    
    // MARK: - Set Constraints
    
    override func setConstraints() {
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15.73)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(38.27)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(textView)
        }
        
        if hasIndicator {
            characterCountLabel.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(17)
                $0.bottom.equalToSuperview().inset(14)
            }
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        // textView 텍스트 변경 감지
        textView.rx.didChange
            .withUnretained(self)
            .bind(with: self, onNext: { owner, _ in
                let text = owner.textView.text ?? ""
                
                // maxLength 제한
                if let maxLength = owner.maxLength, text.count > maxLength {
                    owner.textView.text = String(text.prefix(maxLength))
                }
                
                // placeholder 표시/숨김
                owner.placeholderLabel.isHidden = !owner.textView.text.isEmpty
                
                // 글자 수 업데이트
                owner.updateCharacterCount()
                
                // RxSwift로 텍스트 방출
                owner.textRelay.accept(owner.textView.text)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    func getText() -> String {
        return textView.text
    }

    func setText(_ text: String) {
        textView.text = text
        placeholderLabel.isHidden = !text.isEmpty
        updateCharacterCount()
        textRelay.accept(text)
    }
    
    func setEditable(_ isEditable: Bool) {
        textView.isEditable = isEditable
        textView.isSelectable = isEditable
        textView.backgroundColor = isEditable ? .white : .customColor(.dropDownGray)

        if !isEditable {
            textView.text = ""
            placeholderLabel.isHidden = false
            updateCharacterCount()
            textRelay.accept("")
        }
    }

    // MARK: - Private Methods

    private func updateCharacterCount() {
        guard hasIndicator else { return }
        let currentCount = textView.text.count
        if let max = maxLength {
            characterCountLabel.text = "\(currentCount) / \(max)"
        }
    }
}

// MARK: - Reactive Extension

extension Reactive where Base: PlaceholderTextView {
    var text: Observable<String> {
        return base.textRelay.asObservable()
    }
}
