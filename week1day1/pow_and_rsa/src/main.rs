use std::time::SystemTime;
use ring::signature::KeyPair;
use sha2::*;

fn main() {
    println!("{}", "=".repeat(10* 8));
    let zero_4 = pow(4);
    println!("{}", "=".repeat(10* 8));
    pow(5);
    println!("{}", "=".repeat(10* 8));
    verify(zero_4.as_str());
}

fn pow(need_zero_num: usize) -> String {
    println!("zero_num: {}", need_zero_num);
    let sys = SystemTime::now();
    // let need_zero_num = 4;
    let need_zero_num_str = "0".repeat(need_zero_num);
    let mut nonce = 0;
    let mut data = format!("{}{}", "dawn_clay", nonce);
    let mut hasher0 = Sha256::new();
    hasher0.update(&data);
    let re0 = hasher0.finalize();
    let mut re0_hex = format!("{:x}", re0);
    loop {
        // 计算hash
        if re0_hex.starts_with(&need_zero_num_str) {
            break;
        }
        nonce += 1;
        data = format!("{}{}", "dawn_clay", nonce);
        let mut hasher0 = Sha256::new();
        hasher0.update(&data);
        let re0 = hasher0.finalize();
        re0_hex = format!("{:x}", re0);
    }
    println!("hash_data: {}", data);
    println!("hash: {}", re0_hex);
    // 统计时间-结束
    let sys1 = SystemTime::now();
    let duration =  sys1.duration_since(sys).unwrap();
    println!("time: {:?}ms", duration.as_millis());
    return re0_hex;
} 

fn verify(data: &str) {
    // let data = "0000bed15bf64e1a5eec737a549954e69a83a21cf836368599cf09aeb4ce1ab5";
    // 密钥对
    // ring::signature::EcdsaKeyPair

    let rng = ring::rand::SystemRandom::new();
    let pkcs8 = ring::signature::Ed25519KeyPair::generate_pkcs8(&rng).unwrap();
    let keypair = ring::signature::Ed25519KeyPair::from_pkcs8(pkcs8.as_ref()).unwrap();
    // 生成签名
    let sign = keypair.sign(data.as_bytes());
    // 验证签名
    let public_key = keypair.public_key();

    // use ring::{rand, signature};
    let v_key = ring::signature::UnparsedPublicKey::new(&ring::signature::ED25519, public_key);
    let is_valid = v_key.verify(data.as_bytes(), sign.as_ref()).is_ok();
    
    println!("{:?}", keypair);
    println!("signature: {:?}", sign.as_ref());
    println!("sucess: {}", is_valid);
}

#[test]
fn test_hash() {
    // dawn_clay nonce
    // let input = "nonce";
    // let mut hasher = Sha256::new();
    // hasher.update(input.as_bytes());
    // let result = hasher.finalize();
    // let hex_hash = format!("{:x}", result);
    // println!("{}", hex_hash);
    // println!("{}", "0".repeat(4));

    // let sys = SystemTime::now();
    // thread::sleep(Duration::from_millis(1000));
    // let sys1 = SystemTime::now();
    // let duration =  sys1.duration_since(sys).unwrap();
    // println!("{:?}ms", duration.as_millis());
    // if true {
    //     return;
    // }
    // 统计时间-开始
    let sys = SystemTime::now();
    let need_zero_num = 4;
    let need_zero_num_str = "0".repeat(need_zero_num);
    let mut nonce = 0;
    let mut data = format!("{}{}", "dawn_clay", nonce);
    let mut hasher0 = Sha256::new();
    hasher0.update(&data);
    let re0 = hasher0.finalize();
    let mut re0_hex = format!("{:x}", re0);
    loop {
        // 计算hash
        if re0_hex.starts_with(&need_zero_num_str) {
            break;
        }
        nonce += 1;
        data = format!("{}{}", "dawn_clay", nonce);
        let mut hasher0 = Sha256::new();
        hasher0.update(&data);
        let re0 = hasher0.finalize();
        re0_hex = format!("{:x}", re0);
    }
    println!("hash_data: {}", data);
    println!("hash: {}", re0_hex);
    // 统计时间-结束
    let sys1 = SystemTime::now();
    let duration =  sys1.duration_since(sys).unwrap();
    println!("time: {:?}ms", duration.as_millis());
    
}


#[test]
fn test_rsa() {
    // 0000bed15bf64e1a5eec737a549954e69a83a21cf836368599cf09aeb4ce1ab5
    let data = "0000bed15bf64e1a5eec737a549954e69a83a21cf836368599cf09aeb4ce1ab5";
    // 密钥对
    // ring::signature::EcdsaKeyPair

    let rng = ring::rand::SystemRandom::new();
    let pkcs8 = ring::signature::Ed25519KeyPair::generate_pkcs8(&rng).unwrap();
    let keypair = ring::signature::Ed25519KeyPair::from_pkcs8(pkcs8.as_ref()).unwrap();
    // 生成签名
    let sign = keypair.sign(data.as_bytes());
    // 验证签名
    let public_key = keypair.public_key();

    // use ring::{rand, signature};
    let v_key = ring::signature::UnparsedPublicKey::new(&ring::signature::ED25519, public_key);
    let is_valid = v_key.verify(data.as_bytes(), sign.as_ref()).is_ok();
    
    println!("{:?}", keypair);
    println!("{:?}", sign.as_ref());
    println!("{}", is_valid);
}
