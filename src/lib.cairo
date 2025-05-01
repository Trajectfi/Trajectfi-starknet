pub mod components {
    pub mod admin;
    pub mod logics;
    pub mod operations;
    pub mod signing;
}
pub mod errors;
pub mod interfaces {
    pub mod iadmin;
    pub mod ierc20;
    pub mod ierc721;
    pub mod ioperations;
    pub mod itrajectfi;
}
pub mod types;

#[cfg(test)]
pub mod tests {
    pub mod test_admin;
    pub mod test_operations;
    pub mod test_trajectfi;
    pub mod test_logics;
    pub mod test_utils;
}

pub mod trajectfi;
