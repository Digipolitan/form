//
//  ViewController.swift
//  RoadblockSample-iOS
//
//  Created by Benoit BRIATTE on 23/12/2016.
//  Copyright © 2016 Digipolitan. All rights reserved.
//

import UIKit
import Roadblock

class ViewController: UIViewController {

    public enum Fields {
        public static var email = "email"
        public static var password = "password"
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    public var form: Form!
    private var formTextFieldChainable: FormTextFieldDelegateChainable?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.form = Form(fields: [
            .init(identifier: Fields.email,
                  target: self.emailTextField,
                  name: "email",
                  validator: FieldValidators.group(FieldValidators.required(), FieldValidators.email()),
                  transformer: FieldTransformers.group(FieldTransformers.trim(), FieldTransformers.emptyIsNil())),
            .init(identifier: Fields.password,
                  target: self.passwordTextField,
                  name: "password",
                  validator: FieldValidators.group(FieldValidators.required()),
                  transformer: FieldTransformers.group(FieldTransformers.trim(), FieldTransformers.emptyIsNil()))
            ], delegate: self)

        let formTextFieldChainable = FormTextFieldDelegateChainable(form: self.form)
        self.emailTextField.delegate = formTextFieldChainable
        self.passwordTextField.delegate = formTextFieldChainable
        self.formTextFieldChainable = formTextFieldChainable
    }

    @IBAction func validateButtonClicked() {
        self.view.endEditing(true)
        do {
            try self.form.validate()
        } catch {
            if let err = error as? FormError {
                let alertController = UIAlertController(title: "Error", message:
                    err.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))

                self.present(alertController, animated: true, completion: nil)
            }
        }
        return
    }
}

extension ViewController: FormDelegate {

    func formDidSubmit(_ form: Form) {
        self.validateButtonClicked()
    }
}
